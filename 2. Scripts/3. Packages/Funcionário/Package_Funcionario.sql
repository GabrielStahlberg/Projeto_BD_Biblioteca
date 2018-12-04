create or replace package func as
    procedure cadastrar_funcionario(func_prontuario funcionario.func_prontuario%type,
                                    func_endereco funcionario.func_endereco%type,
                                    func_nome funcionario.func_nome%type,
                                    func_dt_nasc funcionario.func_data_nasc%type,
                                    func_telefone funcionario.func_telefone%type);
                                
    procedure atualizar_funcionario_tel(func_pront funcionario.func_prontuario%type,
                                        func_tel funcionario.func_telefone%type);
    
    procedure excluir_funcionario(func_pront funcionario.func_prontuario%type);
    
    invalid_func_prontuario exception;
end func;
/

---------------------------------------------

create or replace package body func as
    procedure cadastrar_funcionario(func_prontuario funcionario.func_prontuario%type,
                                    func_endereco funcionario.func_endereco%type,
                                    func_nome funcionario.func_nome%type,
                                    func_dt_nasc funcionario.func_data_nasc%type,
                                    func_telefone funcionario.func_telefone%type)
    is
        insert_null_exception exception;
        pragma exception_init(insert_null_exception, -01400);
    begin
        insert into funcionario
        values(func_prontuario, func_endereco, func_nome, func_dt_nasc, func_telefone);
        
        dbms_output.put_line('Funcionário cadastrado com sucesso !');
        
        commit;
    exception
        when insert_null_exception then
            rollback;
            dbms_output.put_line('Erro ao tentar inserir valor nulo. Tente novamente.');
            dbms_output.put_line(sqlerrm);
        when others then
            rollback;
            dbms_output.put_line('Erro ao cadastrar funcionário. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end cadastrar_funcionario;
    
    
    
    procedure atualizar_funcionario_tel(func_pront funcionario.func_prontuario%type,
                                        func_tel funcionario.func_telefone%type)
    is
        invalid_func_tel exception;
    begin
        if func_tel is null then
            raise invalid_func_tel;
        end if;
        
        update funcionario
        set func_telefone = func_tel
        where func_prontuario = func_pront;
        
        if sql%notfound then
            raise invalid_func_prontuario;
        end if;
        
        dbms_output.put_line('Telefone de funcionário atualizado com sucesso !');
        
        commit;
    exception
        when invalid_func_tel then
            rollback;
            dbms_output.put_line('Telefone inválido. Tente novamente.');
        when invalid_func_prontuario then
            rollback;
            dbms_output.put_line('Prontuário não encontrado. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao atualizar telefone de funcionário. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end atualizar_funcionario_tel;
    
    
    
    procedure excluir_funcionario(func_pront funcionario.func_prontuario%type)
    is
    begin
        delete from funcionario
        where func_prontuario = func_pront;
        
        if sql%notfound then
            raise invalid_func_prontuario;
        end if;
        
        dbms_output.put_line('Funcionário excluído com sucesso !');
        
        commit;
    exception
        when invalid_func_prontuario then
            rollback;
            dbms_output.put_line('Prontuário não encontrado. Tente novamente.');
        when others then
            rollback;
            dbms_output.put_line('Erro ao exclior funcionário. Tente novamente.');
            dbms_output.put_line(sqlerrm);
    end excluir_funcionario;
end func;
/