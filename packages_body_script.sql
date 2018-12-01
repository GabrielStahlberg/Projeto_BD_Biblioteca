create or replace package body relatorio as

    /* LISTA DE TODAS AS OBRAS QUE ESTÃO EMPRESTADAS NO MOMENTO */
    procedure obras_emprestadas is
        nome_leitor varchar(50);
        titulo_obra varchar(50);
        id_exemplar number;
        data_emp date;
        data_prev_emp date;
    begin
        select l.leitor_nome, o.obra_titulo, e.exemplar_id, em.emp_data, em.emp_data_prev_dev
        into nome_leitor, titulo_obra, id_exemplar, data_emp, data_prev_emp
        from emprestimo em
        inner join leitores l
        on l.leitor_id = em.leitor_id
        inner join exemplar e
        on e.exemplar_id = em.exemplar_id
        inner join obras o
        on e.obra_id = o.obra_id
        where e.exemplar_status = 'Indisponivel'
        order by o.cat_obra_cod;
        
        dbms_output.put_line('***** LISTA DE OBRAS EMPRESTADAS *****');
        dbms_output.put_line('');
        
        dbms_output.put_line('Nome do leitor: ' || nome_leitor);
        dbms_output.put_line('Título da obra: ' || titulo_obra);
        dbms_output.put_line('ID do exemaplar: ' || id_exemplar);
        dbms_output.put_line('Data do empréstimo: ' || data_emp);
        dbms_output.put_line('Data prevista para devolução: ' || data_prev_emp);
        dbms_output.put_line('--------------------------------------------');
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Todos os exemplares de todas as obras estão disponíveis');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end obras_emprestadas;
    
    /* LISTA DE TODAS AS OBRAS QUE ESTÃO ATRASADAS NO MOMENTO */
    procedure obras_atrasadas is
        nome_leitor varchar(50);
        telefone_leitor varchar(50);
        email_leitor varchar(50);
        data_emp date;
        data_prev_emp date;
    begin
        select l.leitor_nome, l.leitor_telefone, l.leitor_email, em.emp_data, em.emp_data_prev_dev
        into nome_leitor, telefone_leitor, email_leitor, data_emp, data_prev_emp
        from emprestimo em
        inner join leitores l
        on l.leitor_id = em.leitor_id
        where em.emp_data_prev_dev < sysdate
        and em.emp_data_real_dev is null;
        
        dbms_output.put_line('***** LISTA DE OBRAS ATRASADAS *****');
        dbms_output.put_line('');
        
        dbms_output.put_line('Nome do leitor: ' || nome_leitor);
        dbms_output.put_line('Telefone do leitor: ' || telefone_leitor);
        dbms_output.put_line('E-Mail do leitor: ' || email_leitor);
        dbms_output.put_line('Data do empréstimo: ' || data_emp);
        dbms_output.put_line('Data prevista para devolução: ' || data_prev_emp);
        dbms_output.put_line('--------------------------------------------');
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Não há obras atrasadas');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end obras_atrasadas;
    
    procedure obras_reservadas is
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
    end obras_reservadas;
    
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
    
    procedure consulta_obra(p_obra_id number) is
        totalObra number;
        titulo varchar(256);
        qtdeEmprestados number;
        qtdeReservados number;
        qtdeDisponivel number;
    begin
        select obra_qtde_total into totalObra
        from obras
        where obra_id = p_obra_id;
        
        if sql%notfound then
            raise invalid_id;
        end if;
        
        select obra_titulo into titulo
        from obras
        where obra_id = p_obra_id;
        
        select count(*) into qtdeEmprestados
        from exemplar e 
        where e.obra_id = p_obra_id
        and e.exemplar_status = 'Indisponivel';
        
        select count(*) into qtdeReservados
        from reserva r
        where r.obra_id = p_obra_id;
        
        select count(*) into qtdeDisponivel
        from exemplar e
        where e.obra_id = p_obra_id
        and e.exemplar_status = 'Disponivel';
        
        if qtdeEmprestados = totalObras then
            dbms_output.put_line('Situação: Indisponível');
        else
            dbms_output.put_line('Situação: Disponível');
            dbms_output.put_line('Título: ' || titulo);
            dbms_output.put_line('Qtde exemplares: ' || totalObra);
            dbms_output.put_line('Qtde emprestado: ' || qtdeEmprestados);
            dbms_output.put_line('Qtde reservados: ' || qtdeReservados);
            dbms_output.put_line('Qtde Disponível: ' || qtdeDisponivel);
        end if;

    exception
        when invalid_id then
            dbms_output.put_line('Obra não encontrada. Tente com outro id.');
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

    /* EFETUA A DEVOLUÇÃO */
    procedure efetuar_devolucao(p_exemplar_id number) is
        data_prev date;
        data_real date := sysdate;
        leitor number;
    begin
        select e.emp_data_prev_dev, e.leitor_id into data_prev, leitor
        from emprestimo e
        where e.exemplar_id = p_exemplar_id;
        
        if data_real > data_prev then
            update leitores l
            set l.leitor_status_emprestimo = 0
            where l.leitor_id = leitor;
        end if;
        
        update emprestimo
        set emp_data_real_dev = data_real
        where exemplar_id = p_exemplar_id;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Exemplar não encontrado, tente outro id.');
    end efetuar_devolucao;
    
    /* EFETUA O EMPRÉSTIMO */
    procedure efetuar_emprestimo(p_leitor_id number, p_pront_func varchar, p_exemplar_id number) is
        data_prev date;
        dias_max number;
        existe_func boolean;
        funcionario_exc exception;
        exemplar_exc exception;
        inativo_exc exception;
        estaDisponivel boolean;
        leitorAtivo number;
    begin
        select l.leitor_status_emprestimo into leitor_ativo
        from leitores l
        where l.leitor_id = p_leitor_id;
        
        if leitorativo = 0 then
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
        
        estadisponivel := verifica_disponibilidade(p_exemplar_id);
        
        if not estaDisponivel then
            raise exemplar_exc;
        end if;
        
        insert into emprestimo(emp_id, emp_data, emp_data_prev_dev, exemplar_id, leitor_id, func_prontuario)
        values(emprestimo_seq.nextval, sysdate, data_prev, p_exemplar_id, p_leitor_id, p_pront_func);
    exception
        when funcionario_exc then
            dbms_output.put_line('Funcionário não existe.');
        when funcionario_exc then
            dbms_output.put_line('Leitor está inativo para empréstimo. Regularize a situação e tente novamente');
        when exemplar_exc then
            dbms_output.put_line('O Exemplar não está disponível no momento.');
        when NO_DATA_FOUND then
            dbms_output.put_line('Leitor não encontrado, tente outro id.');
    end efetuar_emprestimo;
    
    /* VERIFICA DISPONIBILIDADE DO EXEMPLAR */
    function verifica_disponibilidade(p_exemplar_id number) return boolean is
        disponivel boolean := true;
        status varchar(20);
    begin
        select exemplar_status into status
        from exemplar e
        where e.exemplar_id = p_exemplar_id;
        
        if status = 'Indisponivel' then
            disponivel := false;
        end if;
        return disponivel;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Exemplar não encontrado, tente outro id.');
    end verifica_disponibilidade;

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