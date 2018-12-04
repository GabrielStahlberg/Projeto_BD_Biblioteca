create or replace package relatorio as
    procedure obras_emprestadas;
    procedure obras_atrasadas;
    procedure obras_reservadas;
    procedure historico_leitor(p_leitor_id number);
    procedure consulta_obra(p_obra_id number);
    
    invalid_id exception;
end relatorio;
/

-----------------------------------------------

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
    
    /* LISTA COM TODAS AS OBRAS QUE ESTÃO RESERVADAS */
    procedure obras_reservadas is
        cursor reserva_c is
            select l.leitor_nome, l.leitor_telefone, l.leitor_email, o.obra_titulo
            from reserva r
            inner join obras o
            on r.obra_id = o.obra_id
            inner join leitores l
            on r.leitor_id = l.leitor_id
            where r.data_emprestimo_efetuado is null;
        reserva_rec reserva_c%rowtype;
    begin
        dbms_output.put_line('***** LISTA DE OBRAS RESERVADAS *****');
        dbms_output.put_line('');
        open reserva_c;
        loop
            fetch reserva_c into reserva_rec;
            exit when reserva_c%notfound;
            
                dbms_output.put_line('Nome do leitor: ' || reserva_rec.leitor_nome);
                dbms_output.put_line('Telefone do leitor: ' || reserva_rec.leitor_telefone);
                dbms_output.put_line('E-Mail do leitor: ' || reserva_rec.leitor_email);   
                dbms_output.put_line('Título da obra: ' || reserva_rec.obra_titulo);
            
        end loop;
        close reserva_c;        
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