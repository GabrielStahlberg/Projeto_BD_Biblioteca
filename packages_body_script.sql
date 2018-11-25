create or replace package body relatorio as

    procedure obras_emprestadas is
    begin
        select *
        from exemplar
        where exemplar_status = 'Indisponivel';
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Todos os exemplares de todas as obras estão disponíveis');
        when others then
            dbms_output.put_line(SQLCODE);
            dbms_output.put_line(SQLERRM);
    end obras_emprestadas;
    
    procedure obras_atrasadas is
        dataAtual date := sysdate;
    begin
        select e.exemplar_id, o.obra_titulo
        from emprestimo e
        inner join exemplar ex on ex.exemplar_id = e.exemplar_id
        inner join obras o on ex.obra_id = o.obra_id
        where e.emp_data_prev_dev < dataAtual
        and e.emp_data_real_dev = null;
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
    
    procedure historico_leitor(p_leitor_id number) is
    begin
        select o.obra_titulo, e.emp_data, e.emp_data_prev_dev, e.emp_data_real_dev
        from emprestimo e
        inner join exemplar ex using(exemplar_id)
        inner join obras o on ex.obra_id = o.obra_id
        where e.leitor_id = p_leitor_id;
        
        if sql%notfound then
            raise invalid_id;
        end if;
    exception
        when invalid_id then
            dbms_output.put_line('Leitor não encontrado. Tente com outro id.');
        when NO_DATA_FOUND then
            dbms_output.put_line('Não há obras reservadas');
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