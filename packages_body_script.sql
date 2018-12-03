create or replace package body relatorio as
    
    /* LISTA DE TODAS AS OBRAS QUE ESTÃO EMPRESTADAS NO MOMENTO */
    procedure obras_emprestadas is        
        cursor emp_c is
            select l.leitor_nome, o.obra_titulo, e.exemplar_id, em.emp_data, em.emp_data_prev_dev
            from emprestimo em
            inner join leitores l
            on l.leitor_id = em.leitor_id
            inner join exemplar e
            on e.exemplar_id = em.exemplar_id
            inner join obras o
            on e.obra_id = o.obra_id
            where e.exemplar_status != 'Disponivel'
            and em.emp_data_real_dev is null
            order by o.cat_obra_cod;
        emp_rec emp_c%rowtype;
    begin
        dbms_output.put_line('***** LISTA DE OBRAS EMPRESTADAS *****');
        dbms_output.put_line('');
        open emp_c;
        loop
            fetch emp_c into emp_rec;
            exit when emp_c%notfound;
            
                dbms_output.put_line('Nome do leitor: ' || emp_rec.leitor_nome);
                dbms_output.put_line('Título da obra: ' || emp_rec.obra_titulo);
                dbms_output.put_line('ID do exemaplar: ' || emp_rec.exemplar_id);
                dbms_output.put_line('Data do empréstimo: ' || emp_rec.emp_data);
                dbms_output.put_line('Data prevista para devolução: ' || emp_rec.emp_data_prev_dev);
                dbms_output.put_line('--------------------------------------------');
            
        end loop;
        close emp_c;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Todos os exemplares de todas as obras estão disponíveis');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end obras_emprestadas;
    
    /* LISTA TODAS OS EXEMPLARES QUE NESSE MOMENTO ESTÃO ATRASADOS */ 
    procedure obras_atrasadas is
        cursor atrasados_c is
            select l.leitor_nome, l.leitor_telefone, l.leitor_email, em.emp_data, em.emp_data_prev_dev
            from emprestimo em
            inner join leitores l
            on l.leitor_id = em.leitor_id
            where em.emp_data_prev_dev < sysdate
            and em.emp_data_real_dev is null;
        atrasados_rec atrasados_c%rowtype;
    begin
        dbms_output.put_line('***** LISTA DE OBRAS ATRASADAS *****');
        dbms_output.put_line('');
        open atrasados_c;
        loop
            fetch atrasados_c into atrasados_rec;
            exit when atrasados_c%notfound;            
                dbms_output.put_line('Nome do leitor: ' || atrasados_rec.leitor_nome);
                dbms_output.put_line('Telefone do leitor: ' || atrasados_rec.leitor_telefone);
                dbms_output.put_line('E-Mail do leitor: ' || atrasados_rec.leitor_email);
                dbms_output.put_line('Data do empréstimo: ' || atrasados_rec.emp_data);
                dbms_output.put_line('Data prevista para devolução: ' || atrasados_rec.emp_data_prev_dev);
                dbms_output.put_line('--------------------------------------------');
        end loop;
        close atrasados_c;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Não há obras atrasadas');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end obras_atrasadas;
    
    /*procedure obras_reservadas is
    begin
        select r.obra_id, o.obra_titulo
        from reserva r
        inner join obras o on r.obra_id = o.obra_id;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Não há obras reservadas');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end obras_reservadas;*/
    
    /* MOSTRA TODO O HISTÓRICO DE EMPRÉSTIMOS DE UM DETERMINADO LEITOR */
    procedure historico_leitor(p_leitor_id number) is       
        cursor c_dados is
            select o.obra_titulo, em.emp_data, em.emp_data_prev_dev, NVL(to_char(em.emp_data_real_dev), 'Pendente') Devolucao
            from emprestimo em
            inner join exemplar e
            on em.exemplar_id = e.exemplar_id
            inner join obras o
            on o.obra_id = e.obra_id
            where em.leitor_id = p_leitor_id;
            
        dados_rec c_dados%rowtype;            
    begin
        dbms_output.put_line('***** HISTÓRICO DE EMPRÉSTIMOS *****');
        dbms_output.put_line('');
        open c_dados;
        loop
            fetch c_dados into dados_rec;
            exit when c_dados%notfound;      
                dbms_output.put_line('Título da obra: ' || dados_rec.obra_titulo || ' | ' || 'Data do empréstimo: ' 
                    || dados_rec.emp_data || ' | ' || 'Data prevista para devolução: ' || dados_rec.emp_data_prev_dev
                    || ' | ' || 'Data da devolução: ' || dados_rec.devolucao);
        end loop;
        close c_dados;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Não há registros de empréstimos desse leitor');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end historico_leitor;
    
    /* FAZ UMA CONSULTA PARA VERIFICAR DETERMINADA OBRA */
    procedure consulta_obra(p_obra_id number) is
        totalObra number;
        titulo varchar(256);
        qtdeEmprestados number;
        qtdeReservados number;
        qtdeDisponivel number;
        situacao varchar(20) := 'Disponível';
    begin
        select obra_qtde_total, obra_titulo
        into totalObra, titulo
        from obras
        where obra_id = p_obra_id;
        
        select count(*) into qtdeEmprestados
        from exemplar e 
        where e.obra_id = p_obra_id
        and e.exemplar_status = 'Indisponivel';
        
        select count(*) into qtdeReservados
        from reserva r
        where r.obra_id = p_obra_id;
        
        qtdeDisponivel := totalobra - qtdeemprestados;
        
        if qtdeEmprestados = totalObra then
            situacao := 'Indisponível';
        end if;        
            dbms_output.put_line('Situação: ' || situacao);
            dbms_output.put_line('Título: ' || titulo);
            dbms_output.put_line('Qtde exemplares: ' || totalObra);
            dbms_output.put_line('Qtde emprestado: ' || qtdeEmprestados);
            dbms_output.put_line('Qtde reservados: ' || qtdeReservados);
            dbms_output.put_line('Qtde Disponível: ' || qtdeDisponivel);

    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Não há obras encontradas');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end consulta_obra;
end relatorio;
/



---------------------------------------------



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
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Obra não encontrada, tente outro id.');
        when obra_disponivel_exc then
            dbms_output.put_line('Não é possível efetuar a reserva. Há exemplar(es) dessa obra disponível(is).');
    end efetuar_reserva;
    
    /* VERIFICA DISPONIBILIDADE DA OBRA */
    function verifica_disp_obra(p_obra_id number) return boolean is
        qtdeDisponivel number;
        estaDisponivel boolean := true;
    begin
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
    begin
        select e.emp_data_prev_dev, e.leitor_id into data_prev, leitor
        from emprestimo e
        where e.exemplar_id = p_exemplar_id
        and e.emp_data_real_dev is null;
        
        -- VERIFICA SE ENTREGOU NO PRAZO
        if data_real > data_prev then
            update leitores l
            set l.leitor_status_emprestimo = 0
            where l.leitor_id = leitor;
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
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Exemplar não encontrado, tente outro id.');
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
        select l.leitor_status_emprestimo into leitorAtivo
        from leitores l
        where l.leitor_id = p_leitor_id;
        
        if leitorAtivo = 0 then
            raise inativo_exc;
        end if;
        
        select c.cat_leitor_max_dias into dias_max
        from leitores l
        inner join categoria_leitor c
        on l.cat_leitor_cod = c.cat_leitor_cod
        where l.leitor_id = p_leitor_id;        
    
        data_prev := sysdate + dias_max;        
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
            -- PASSAR O LEITOR COMO PARÂMETRO E VALIDAR SE ELE ESTÁ EMPRESTANDO À PARTIR DE UMA RESERVA
            estadisponivel := verifica_disp_exemplar(p_exemplar_id);        
            if not estaDisponivel then
                raise exemplar_exc;
            end if;
        end if;       

        insert into emprestimo(emp_id, emp_data, emp_data_prev_dev, exemplar_id, leitor_id, func_prontuario)
        values(emprestimo_seq.nextval, sysdate, data_prev, p_exemplar_id, p_leitor_id, p_pront_func);
        
    exception
        when funcionario_exc then
            dbms_output.put_line('Funcionário não existe.');
        when expirado_exc then
            dbms_output.put_line('Seu período de reserva de 3 dias foi expirado.');
        when inativo_exc then
            dbms_output.put_line('Leitor está inativo para empréstimo. Regularize a situação e tente novamente');
        when exemplar_exc then
            dbms_output.put_line('O Exemplar não está disponível no momento.');
        when NO_DATA_FOUND then
            dbms_output.put_line('Leitor não encontrado, tente outro id.');
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