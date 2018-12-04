create or replace package categ_leitor as
    procedure cadastrar_categ_leitor(cat_leitor_cod categoria_leitor.cat_leitor_cod%type,
                                         cat_leitor_desc categoria_leitor.cat_leitor_desc%type,
                                         cat_leitor_max_dias categoria_leitor.cat_leitor_max_dias%type);
    
    procedure atualizar_categ_leitor_desc(cat_leit_cod categoria_leitor.cat_leitor_cod%type,
                                          cat_leit_desc categoria_leitor.cat_leitor_desc%type);
                                        
    procedure excluir_categ_leitor(cat_leit_cod categoria_leitor.cat_leitor_cod%type);
    
    invalid_cat_leitor_cod exception;
end categ_leitor;
/

----------------------------------------------

create or replace package body categ_leitor as
    procedure cadastrar_categ_leitor(cat_leitor_cod categoria_leitor.cat_leitor_cod%type,
                                         cat_leitor_desc categoria_leitor.cat_leitor_desc%type,
                                         cat_leitor_max_dias categoria_leitor.cat_leitor_max_dias%type)
    is
        insert_null_exception exception;
        pragma exception_init(insert_null_exception, -01400);
        
        categ_cod_exists exception;
        pragma exception_init(categ_cod_exists, -00001);
    begin
        insert into categoria_leitor
        values(cat_leitor_cod, cat_leitor_desc, cat_leitor_max_dias);
    
        dbms_output.put_line('Categoria de leitor cadastrada com sucesso !');
        
        commit;
    exception
        when insert_null_exception then
            rollback;
            dbms_output.put_line('Erro ao tentar inserir valor nulo. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when categ_cod_exists then
            rollback;
            dbms_output.put_line('Código de categoria de leitor já existe. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when others then
            rollback;
            dbms_output.put_line('Erro ao inserir categoria de leitor. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end cadastrar_categ_leitor;
                                             
    
    
    procedure atualizar_categ_leitor_desc(cat_leit_cod categoria_leitor.cat_leitor_cod%type,
                                          cat_leit_desc categoria_leitor.cat_leitor_desc%type)
    is
        invalid_cat_leit_desc exception;
    begin
        if cat_leit_desc is null then
            raise invalid_cat_leit_desc;
        end if;
        
        update categoria_leitor
        set cat_leitor_desc = cat_leit_desc
        where cat_leitor_cod = cat_leit_cod;
        
        if sql%notfound then
            raise invalid_cat_leitor_cod;
        end if;
        
        dbms_output.put_line('Descrição de categoria de leitor atualizada com sucesso !');
    
        commit;
    exception 
        when invalid_cat_leit_desc then
            rollback;
            dbms_output.put_line('Descrição de categoria de leitor inválida. Tente novamente.');
        when invalid_cat_leitor_cod then
            rollback;
            dbms_output.put_line('Código de categoria de leitor não encontrado. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao atualizar categoria de leitor. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end atualizar_categ_leitor_desc;
    
    
    
    procedure excluir_categ_leitor(cat_leit_cod categoria_leitor.cat_leitor_cod%type)
    is
    begin
        delete from categoria_leitor
        where cat_leitor_cod = cat_leit_cod;
        
        if sql%notfound then
            raise invalid_cat_leitor_cod;
        end if;
        
        dbms_output.put_line('Categoria de leitor excluída com sucesso !');
        
        commit;
    exception
        when invalid_cat_leitor_cod then
            rollback;
            dbms_output.put_line('Código de categoria de leitor inválido. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao excluir categoria de leitor. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end excluir_categ_leitor;
end categ_leitor;
/