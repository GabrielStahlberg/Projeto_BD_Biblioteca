create or replace package categ_obra as
    procedure cadastrar_cat_obra(cat_ob_cod categoria_obra.cat_obra_cod%type,
                                 cat_ob_desc categoria_obra.cat_obra_desc%type);

    procedure atualizar_cat_obra_desc(cat_ob_cod categoria_obra.cat_obra_cod%type,
                                      cat_ob_desc categoria_obra.cat_obra_desc%type);

    procedure excluir_cat_obra(cat_ob_cod categoria_obra.cat_obra_cod%type);
    
    invalid_cat_obra_cod exception;
end categ_obra;
/

-------------------------------------------------

create or replace package body categ_obra as
    procedure cadastrar_cat_obra(cat_ob_cod categoria_obra.cat_obra_cod%type,
                                 cat_ob_desc categoria_obra.cat_obra_desc%type)
    is
        insert_null_exception exception;
        pragma exception_init(insert_null_exception, -01400);
        
        categ_obra_cod_exists exception;
        pragma exception_init(categ_obra_cod_exists, -00001);  
    begin
        insert into categoria_obra
        values(cat_ob_cod, cat_ob_desc);
    
        dbms_output.put_line('Categoria de obra cadastrada com sucesso !');
        
        commit;
    exception
        when insert_null_exception then
            rollback;
            dbms_output.put_line('Erro ao tentar inserir valor nulo. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when categ_obra_cod_exists then
            rollback;
            dbms_output.put_line('Código de categoria de obra já existe. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao inserir categoria de obra. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end cadastrar_cat_obra;



    procedure atualizar_cat_obra_desc(cat_ob_cod categoria_obra.cat_obra_cod%type,
                                      cat_ob_desc categoria_obra.cat_obra_desc%type)
    is
        invalid_cat_obra_desc exception;
    begin
       if cat_ob_desc is null then
            raise invalid_cat_obra_desc;
        end if;
        
        update categoria_obra
        set cat_obra_desc = cat_ob_desc 
        where cat_obra_cod = cat_ob_cod;
        
        if sql%notfound then
            raise invalid_cat_obra_cod;
        end if;
    
        dbms_output.put_line('Descrição de categoria de obra atualizada com sucesso !');
 
        commit;
    exception
        when invalid_cat_obra_desc then
            rollback;
            dbms_output.put_line('Descrição de categoria de obra inválida. Tente novamente.');
        when invalid_cat_obra_cod then
            rollback;
            dbms_output.put_line('Código de categoria de obra não encontrado. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao atualizar descrição de categoria de obra. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end atualizar_cat_obra_desc;
    
    
    
    procedure excluir_cat_obra(cat_ob_cod categoria_obra.cat_obra_cod%type)
    is
    begin
        delete from categoria_obra
        where cat_obra_cod = cat_ob_cod;
        
        if sql%notfound then
            raise invalid_cat_obra_cod;
        end if;
        
        dbms_output.put_line('Categoria de obra excluída com sucesso !');
        
        commit;
    exception
        when invalid_cat_obra_cod then
            rollback;
            dbms_output.put_line('Código de categoria de obra inválida. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao excluir categoria de obra. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end excluir_cat_obra;
end categ_obra;
/