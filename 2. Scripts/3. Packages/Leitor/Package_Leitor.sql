create or replace package leitor as 
    procedure cadastrar_leitor(leitor_pront leitores.leitor_prontuario%type,
                               leitor_nome leitores.leitor_nome%type,
                               leitor_rg_est leitores.leitor_rg_estado%type,
                               leitor_rg leitores.leitor_rg%type,
                               leitor_uf leitores.leitor_uf%type,
                               leitor_cidade leitores.leitor_cidade%type,
                               leitor_ender leitores.leitor_endereco%type,
                               leitor_email leitores.leitor_email%type,
                               leitor_tel leitores.leitor_telefone%type,
                               leitor_st_emp leitores.leitor_status_emprestimo%type,
                               leitor_dt_nasc leitores.leitor_data_nasc%type,
                               cat_leitor_cod leitores.cat_leitor_cod%type);

    procedure atualizar_leitor_email(leitorid leitores.leitor_id%type,
                                     leitor_em leitores.leitor_email%type);
                                     
    procedure atualizar_leitor_telefone(leitorid leitores.leitor_id%type,
                                        leitor_tel leitores.leitor_telefone%type);
    
    procedure excluir_leitor(leitorid leitores.leitor_id%type);

    invalid_leitor_id exception;
end leitor;
/

----------------------------------

create or replace package body leitor as
    procedure cadastrar_leitor(leitor_pront leitores.leitor_prontuario%type,
                               leitor_nome leitores.leitor_nome%type,
                               leitor_rg_est leitores.leitor_rg_estado%type,
                               leitor_rg leitores.leitor_rg%type,
                               leitor_uf leitores.leitor_uf%type,
                               leitor_cidade leitores.leitor_cidade%type,
                               leitor_ender leitores.leitor_endereco%type,
                               leitor_email leitores.leitor_email%type,
                               leitor_tel leitores.leitor_telefone%type,
                               leitor_st_emp leitores.leitor_status_emprestimo%type,
                               leitor_dt_nasc leitores.leitor_data_nasc%type,
                               cat_leitor_cod leitores.cat_leitor_cod%type)
    is
        insert_null_exception exception;
        pragma exception_init(insert_null_exception, -01400);
        
        parent_key_not_found exception;
        pragma exception_init(parent_key_not_found, -02291);
    begin
        insert into leitores
        values(leitor_seq.nextval, leitor_pront, leitor_nome, leitor_rg_est, leitor_rg, leitor_uf, leitor_cidade,
               leitor_ender, leitor_email, leitor_tel, leitor_st_emp, leitor_dt_nasc, cat_leitor_cod);
        
        dbms_output.put_line('Leitor cadastrado com sucesso !');
        
        commit;
    exception
        when insert_null_exception then
            rollback;
            dbms_output.put_line('Erro ao tentar inserir valor nulo. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when parent_key_not_found then
            rollback;
            dbms_output.put_line('Categoria de leitor inválida. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when others then
            rollback;
            dbms_output.put_line('Erro ao inserir leitor. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end cadastrar_leitor;
    
    
    
    procedure atualizar_leitor_email(leitorid leitores.leitor_id%type,
                                     leitor_em leitores.leitor_email%type) 
    is
        invalid_email exception;
    begin
        if leitor_em is null then
            raise invalid_email;
        end if;
        
        update leitores
        set leitor_email = leitor_em
        where leitor_id = leitorid;
    
        if sql%notfound then
            raise invalid_leitor_id;
        end if;
    
        dbms_output.put_line('E-mail atualizado com sucesso !');
    
        commit;
    exception
        when invalid_leitor_id then
            rollback;
            dbms_output.put_line('Identificação de leitor inválida. Tente novamente.');
        when invalid_email then
            rollback;
            dbms_output.put_line('E-mail inválido. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao atualizar e-mail. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end atualizar_leitor_email;
    
    
    
    procedure atualizar_leitor_telefone(leitorid leitores.leitor_id%type,
                                        leitor_tel leitores.leitor_telefone%type)
    is
        invalid_tel exception;
    begin
        if leitor_tel is null then
            raise invalid_tel;
        end if;
        
        update leitores
        set leitor_telefone = leitor_tel
        where leitor_id = leitorid;
        
        if sql%notfound then
            raise invalid_leitor_id;
        end if;
        
        dbms_output.put_line('Telefone atualizado com sucesso !');
        
        commit;
    exception
        when invalid_tel then
            rollback;
            dbms_output.put_line('Telefone inválido. Tente novamente.');
        when invalid_leitor_id then
            rollback;
            dbms_output.put_line('Identificação de leitor inválida. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao atualizar telefone. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end atualizar_leitor_telefone;
    
    
    
    procedure excluir_leitor(leitorid leitores.leitor_id%type) is
    begin   
        delete from leitores
        where leitor_id = leitorid;
        
        if sql%notfound then
            raise invalid_leitor_id;
        end if;
        
        dbms_output.put_line('Leitor excluído com sucesso !');
    
        commit;
    exception
        when invalid_leitor_id then
            rollback;
            dbms_output.put_line('Identificação de leitor inválida. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao excluir leitor. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end excluir_leitor;    
end leitor;
/