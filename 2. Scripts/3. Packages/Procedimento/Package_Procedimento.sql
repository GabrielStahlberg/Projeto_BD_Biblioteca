create or replace package procedimento as
    procedure efetuar_emprestimo(p_leitor_id number, p_pront_func varchar, p_exemplar_id number);
    procedure efetuar_reserva(p_obra_id number, p_leitor_id number, p_pront_func varchar);
    procedure efetuar_devolucao(p_exemplar_id number);

    invalid_id exception;
    
    function verifica_funcionario(p_pront_func varchar) return boolean;
    function verifica_disp_exemplar(p_exemplar_id number) return boolean;
    function verifica_disp_obra(p_obra_id number) return boolean;
end procedimento;
/

------------------------------------------

create or replace package body procedimento as
    
    /* EFETUA A RESERVA DE UMA OBRA */
    procedure efetuar_reserva(p_obra_id number, p_leitor_id number, p_pront_func varchar) is
        estaDisponivel boolean;
        obra_disponivel_exc exception;
        id_obra number;
        id_exemplar number;        
        cursor busca_c is
            select r.obra_id
            from reserva r
            where sysdate > r.reserva_data + 3
            and r.data_emprestimo_efetuado is null
            and r.obra_id = p_obra_id;
            
        busca_rec busca_c%rowtype;
    begin
        commit;
        -- CASO HAJA ALGUM EXEMPLAR DA OBRA DISPONÍVEL, NÃO PODERÁ SER EFETUADA A RESERVA
        estaDisponivel := verifica_disp_obra(p_obra_id);        
        if estaDisponivel then
            raise obra_disponivel_exc;
        end if;
        
        -- VERIFICA SE HÁ ALGUMA RESERVA QUE EXPIROU OS 3 DIAS DE PRAZO PARA SER FEITO O EMPRÉSTIMO E FAZ ATUALIZAÇÃO
        open busca_c;
        loop
            fetch busca_c into busca_rec;
            exit when busca_c%notfound;
            
            update exemplar
            set exemplar_status = 'Disponivel'
            where obra_id = busca_rec.obra_id;
            
            -- CASO UMA DAS OBRAS QUE EXPIROU O PRAZO SEJA A OBRA QUE O LEITOR PROCURE, JÁ EFETUA O EMPRÉSTIMO AUTOMATICAMENTE
            if busca_rec.obra_id = p_obra_id then
                select e.exemplar_id into id_exemplar
                from exemplar e
                where e.obra_id = busca_rec.obra_id;
                
                procedimento.efetuar_emprestimo(p_leitor_id, p_pront_func, id_exemplar);
                dbms_output.put_line('Empréstimo automático realizado');
            end if;
        end loop;
        close busca_c;
        
        insert into reserva(reserva_id, reserva_data, leitor_id, obra_id, func_prontuario)
        values(reserva_seq.nextval, sysdate, p_leitor_id, p_obra_id, p_pront_func);
        dbms_output.put_line('Reserva realizada');
        commit;
    exception
        when NO_DATA_FOUND then
            rollback;
            dbms_output.put_line('Obra não encontrada, tente outro id.');
        when obra_disponivel_exc then
            rollback;
            dbms_output.put_line('Não é possível efetuar a reserva. Há exemplar(es) dessa obra disponível(is).');
    end efetuar_reserva;
    
    /* VERIFICA DISPONIBILIDADE DA OBRA */
    function verifica_disp_obra(p_obra_id number) return boolean is
        qtdeDisponivel number;
        estaDisponivel boolean := true;
    begin
        commit;
        select count(*) into qtdeDisponivel
        from exemplar e
        where e.obra_id = p_obra_id
        and e.exemplar_status = 'Disponivel';
                
        if qtdeDisponivel = 0 then
            estaDisponivel := false;
        end if;
        return estaDisponivel;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Obra não encontrada, tente outro id.');
            rollback;
    end verifica_disp_obra;

    /* EFETUA A DEVOLUÇÃO DE UM EXEMPLAR */
    procedure efetuar_devolucao(p_exemplar_id number) is
        data_prev date;
        data_real date := sysdate;
        leitor number;
        leitorNome varchar(50);
        id_obra number;
        possuiReserva number;
        data_emp_reserva number;
        leitor_status number;
        qtdeAtrasado number;
        id_exemplar_atrasado number;
    begin
        commit;
        select e.emp_data_prev_dev, e.leitor_id into data_prev, leitor
        from emprestimo e
        where e.exemplar_id = p_exemplar_id
        and e.emp_data_real_dev is null;

        -- VERIFICA O STATUS DO LEITOR
        select l.leitor_status_emprestimo into leitor_status
        from leitores l
        where l.leitor_id = leitor;

        if leitor_status = 0 then
            select count(*) into qtdeAtrasado
            from emprestimo e
            where e.emp_data_prev_dev < sysdate
            and e.emp_data_real_dev is null
            and e.leitor_id = leitor;
        end if;
        
        -- VERIFICA SE ENTREGOU NO PRAZO
        if data_real > data_prev then
            update leitores l
            set l.leitor_status_emprestimo = 0
            where l.leitor_id = leitor;

            if qtdeAtrasado = 1 then
                select e.exemplar_id into id_exemplar_atrasado
                from emprestimo e
                where e.leitor_id = leitor
                and e.emp_data_real_dev is null;

                if id_exemplar_atrasado = p_exemplar_id then
                    update leitores l
                    set l.leitor_status_emprestimo = 1
                    where l.leitor_id = leitor;
                end if;

            end if;

        end if;
        
        update emprestimo
        set emp_data_real_dev = data_real
        where exemplar_id = p_exemplar_id;
        
        --VERIFICAR SE ESSE EXEMPLAR POSSUI ALGUMA RESERVA
        select e.obra_id into id_obra
        from exemplar e
        where e.exemplar_id = p_exemplar_id;
        
        select count(*) into possuiReserva
        from reserva r
        where r.obra_id = id_obra;
        
        select count(*) into data_emp_reserva
        from reserva r
        where r.obra_id = id_obra
        and r.data_emprestimo_efetuado is null;
        
        if possuiReserva > 0 and data_emp_reserva > 0 then
            select l.leitor_nome into leitorNome
            from reserva r
            inner join leitores l
            on r.leitor_id = l.leitor_id
            where r.obra_id = id_obra
            and rownum = 1
            order by r.reserva_data asc;
            
            insert into mensagens_log(log_id, mensagem)
            values(log_seq.nextval, 'Caro(a) ' || leitornome || ' seu exemplar que estava reservado está, agora, disponível. Há o prazo de 3 dias para que seja retirado. Até logo.');
                    
            update exemplar
            set exemplar_status = 'Reservado'
            where exemplar_id = p_exemplar_id;
        else
            update exemplar
            set exemplar_status = 'Disponivel'
            where exemplar_id = p_exemplar_id;
        end if;
        commit;        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Exemplar não encontrado, tente outro id.');
            rollback;
    end efetuar_devolucao;
    
    /* EFETUA O EMPRÉSTIMO DE UM EXEMPLAR */
    procedure efetuar_emprestimo(p_leitor_id number, p_pront_func varchar, p_exemplar_id number) is
        data_prev date;
        dias_max number;
        existe_func boolean;
        funcionario_exc exception;
        exemplar_exc exception;
        inativo_exc exception;
        expirado_exc exception;
        estaDisponivel boolean;
        leitorAtivo number;
        estavaReservado number;
        id_obra number;
        id_reserva number;
        data_reserva date;
        data_emp_reserva number;
    begin
        commit;
        /* VERIFICA SE O LEITOR ESTÁ ATIVO, OU SEJA, SE PODE EFETUAR EMPRÉSTIMOS */
        select l.leitor_status_emprestimo into leitorAtivo
        from leitores l
        where l.leitor_id = p_leitor_id;
        
        if leitorAtivo = 0 then
            raise inativo_exc;
        end if;
        
        /* VERIFICA O QTDE MÁXIMA DE DIAS QUE ESSE TIPO DE LEITOR PODE FICAR COM O EXEMPLAR E A PARTIR DISSO 
            CALCULA A DATA PREVISTA PARA A DEVOLUÇÃO */
        select c.cat_leitor_max_dias into dias_max
        from leitores l
        inner join categoria_leitor c
        on l.cat_leitor_cod = c.cat_leitor_cod
        where l.leitor_id = p_leitor_id;        
    
        data_prev := sysdate + dias_max; 

        /* VERIFICA A EXISTÊNCIA DESSE FUNCIONÁRIO */       
        existe_func := verifica_funcionario(p_pront_func);
        
        if not existe_func then
            raise funcionario_exc;
        end if;
        
        -- RECUPERA O ID DA OBRA CORRESPONDENTE AO EXEMPLAR SOLICITADO
        select e.obra_id into id_obra
        from exemplar e
        where e.exemplar_id = p_exemplar_id;
        
        -- VERIFICA SE O LEITOR HAVIA RESERVADO ESSA OBRA E SE O PERÍODO NÃO FOI EXPIRADO
        select count(*) into estavaReservado
        from reserva r
        where r.obra_id = id_obra
        and r.leitor_id = p_leitor_id;
        
        -- VERIFICA SE A RESERVA JÁ OBTEVE O EMPRÉSTIMO
        select count(*) into data_emp_reserva
        from reserva r
        where r.obra_id = id_obra
        and r.leitor_id = p_leitor_id
        and r.data_emprestimo_efetuado is null;
        
        if estavaReservado > 0 and data_emp_reserva > 0 then
            select r.reserva_id, r.reserva_data
            into id_reserva, data_reserva
            from reserva r
            where r.obra_id = id_obra
            and r.leitor_id = p_leitor_id;
        
            if data_reserva + 3 < sysdate then
                raise expirado_exc;
            end if;
            update reserva r
            set data_emprestimo_efetuado = sysdate
            where r.reserva_id = id_reserva;
        else
            estadisponivel := verifica_disp_exemplar(p_exemplar_id);        
            if not estaDisponivel then
                raise exemplar_exc;
            end if;
        end if;       

        insert into emprestimo(emp_id, emp_data, emp_data_prev_dev, exemplar_id, leitor_id, func_prontuario)
        values(emprestimo_seq.nextval, sysdate, data_prev, p_exemplar_id, p_leitor_id, p_pront_func);
        commit;
    exception
        when funcionario_exc then
            dbms_output.put_line('Funcionário não existe.');
            rollback;
        when expirado_exc then
            dbms_output.put_line('Seu período de reserva de 3 dias foi expirado.');
            rollback;
        when inativo_exc then
            dbms_output.put_line('Leitor está inativo para empréstimo. Regularize a situação e tente novamente');
            rollback;
        when exemplar_exc then
            dbms_output.put_line('O Exemplar não está disponível no momento.');
            rollback;
        when NO_DATA_FOUND then
            dbms_output.put_line('Leitor não encontrado, tente outro id.');
            rollback;
    end efetuar_emprestimo;
    
    /* VERIFICA DISPONIBILIDADE DO EXEMPLAR */
    function verifica_disp_exemplar(p_exemplar_id number) return boolean is
        disponivel boolean := true;
        status varchar(20);
    begin
        select exemplar_status into status
        from exemplar e
        where e.exemplar_id = p_exemplar_id;
        
        if status = 'Indisponivel' or status = 'Reservado' then
            disponivel := false;
        end if;
        return disponivel;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Exemplar não encontrado, tente outro id.');
    end verifica_disp_exemplar;

    /* VERIFICA EXISTÊNCIA DO FUNCIONÁRIO */
    function verifica_funcionario(p_pront_func varchar) return boolean is
        existe boolean := true;
        achou number;
    begin
        select count(*) into achou
        from funcionario f
        where f.func_prontuario = p_pront_func;

        if sql%notfound then
            raise invalid_id;
        end if;
        
        if achou = 0 then
            existe := false;
        end if;
        return existe;
    exception
        when invalid_id then
            dbms_output.put_line('');
    end verifica_funcionario;    
    
end procedimento;
/