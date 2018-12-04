create or replace package obra_literaria as
    procedure cadastrar_obra(obra_isbn obras.obra_isbn%type,
                             obra_editora obras.obra_editora%type,
                             obra_titulo obras.obra_titulo%type,
                             obra_num_edicao obras.obra_num_edicao%type,
                             obra_qtde_total obras.obra_qtde_total%type,
                             cat_obra_cod obras.cat_obra_cod%type);
                             
    procedure atualizar_qtde_total_obras(obraid obras.obra_id%type,
                                         qtde_nova obras.obra_qtde_total%type);
    
    procedure excluir_obra(obraid obras.obra_id%type);
    
    invalid_obra_id exception;
end obra_literaria;
/

--------------------------------------

create or replace package body obra_literaria as
    procedure cadastrar_obra(obra_isbn obras.obra_isbn%type,
                             obra_editora obras.obra_editora%type,
                             obra_titulo obras.obra_titulo%type,
                             obra_num_edicao obras.obra_num_edicao%type,
                             obra_qtde_total obras.obra_qtde_total%type,
                             cat_obra_cod obras.cat_obra_cod%type)
    is
        insert_null_exception exception;
        pragma exception_init(insert_null_exception, -01400);
    begin
        insert into obras
        values(obra_seq.nextval, obra_isbn, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod);
        
        dbms_output.put_line('Obra cadastrada com sucesso !');
        
        commit;
    exception
        when insert_null_exception then
            rollback;
            dbms_output.put_line('Erro ao tentar inserir valor nulo. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when others then
            rollback;
            dbms_output.put_line('Erro ao inserir obra. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end cadastrar_obra;
    
    
    
    procedure atualizar_qtde_total_obras(obraid obras.obra_id%type,
                                  qtde_nova obras.obra_qtde_total%type)
    is
        invalid_qtde_nova exception;
    begin
        if qtde_nova <= 0 then
            raise invalid_qtde_nova;
        end if;
        
        update obras
        set obra_qtde_total = qtde_nova
        where obra_id = obraid;
        
        if sql%notfound then
            raise invalid_obra_id;
        end if;
    
        dbms_output.put_line('Quantidade de obras atualizada com sucesso !');
        
        commit;
    exception
        when invalid_qtde_nova then
            rollback;
            dbms_output.put_line('Quantidade de obras inválida. Tente novamente !');
        when invalid_obra_id then
            rollback;
            dbms_output.put_line('Identificador de obra inválido. Tente novamente !');
        when others then
            rollback;
            dbms_output.put_line('Erro ao atualizar quantidade de obras. Tente novamente !');
            dbms_output.put_line(sqlerrm);
    end atualizar_qtde_total_obras;
    
    
    
    procedure excluir_obra(obraid obras.obra_id%type) 
    is 
    begin
        delete from obras
        where obra_id = obraid;
        
        if sql%notfound then 
            raise invalid_obra_id;
        end if;
        
        dbms_output.put_line('Obra excluída com sucesso !');
        
        commit;
    exception
        when invalid_obra_id then
            rollback;
            dbms_output.put_line('Identificador de obra inválido. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao excluir obra. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end excluir_obra;
end obra_literaria;
/