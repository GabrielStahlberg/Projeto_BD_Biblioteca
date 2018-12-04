create user admin_biblioteca
identified by adm
default tablespace users
quota 10m on users
temporary tablespace temp;

grant all privileges to admin_biblioteca;

------------------------------------------------------------------------------

create table categoria_leitor(
    cat_leitor_cod varchar(15) primary key,
    cat_leitor_desc varchar(256) not null,
    cat_leitor_max_dias number(2) not null,

    constraint dias_check check(cat_leitor_max_dias > 6)
);

create table leitores(
    leitor_id number(6) primary key,
    leitor_prontuario varchar(20), -- Ou deixar um valor default, caso seja usuário externo e não tenha o prontuário.
    leitor_nome varchar(50) not null,
    leitor_rg_estado varchar(10) not null,
    leitor_rg varchar(20) not null,
    leitor_uf varchar(5),
    leitor_cidade varchar(100),
    leitor_endereco varchar(100) not null,
    leitor_email varchar(50),
    leitor_telefone varchar(50) not null,
    leitor_status_emprestimo number(1,0) default 1,   -- 1 = TRUE(ATIVO)    0 = FALSE(SUSPENSO)
    leitor_data_nasc date not null,
    cat_leitor_cod varchar(15) not null,
    
    constraint cat_leitor_fk foreign key(cat_leitor_cod) references categoria_leitor(cat_leitor_cod) on delete cascade,
    constraint nome_unico unique(leitor_nome),
    constraint email_unico unique(leitor_email),
    constraint prontuario_unico unique(leitor_prontuario)
);

create sequence leitor_seq
increment by 10
start with 10
maxvalue 100000
nocache
nocycle;

create table categoria_obra(
    cat_obra_cod varchar(10) primary key,
    cat_obra_desc varchar(256) not null
);

create table obras(
    obra_id number(6) primary key,
    obra_isbn varchar(20) not null,
    obra_editora varchar(50) not null,
    obra_titulo varchar(50) not null,
    obra_num_edicao number,
    obra_qtde_total number not null,
    cat_obra_cod varchar(10) not null,
    
    constraint cat_obra_fk foreign key(cat_obra_cod)
         references categoria_obra(cat_obra_cod) on delete cascade
);

create sequence obra_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

create table autores(
    autor_nro number primary key,
    autor_nome varchar(256) not null,
    obra_isbn varchar(20) not null
);

create sequence autores_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

create table palavras_chave(
    palavra_id number primary key,
    palavra varchar(100) not null,
    obra_isbn varchar(20) not null
);

create sequence palavras_chave_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

create table exemplar(
    exemplar_id number primary key,
    exemplar_status varchar(20) default 'Disponivel',
    obra_id number(6) not null,
    
    constraint obra_id_fk foreign key(obra_id) references obras(obra_id) on delete cascade
);

create sequence exemplar_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

create table funcionario(
    func_prontuario varchar(20) primary key,
    func_endereco varchar(100) not null, 
    func_nome varchar(50) not null, 
    func_data_nasc date not null, 
    func_telefone varchar(50)
);


create table reserva(
    reserva_id number(6) primary key,
    reserva_data date not null,
    data_emprestimo_efetuado date,
    leitor_id number(6) not null, 
    obra_id number(6) not null,
    func_prontuario varchar(20) not null,
    
    foreign key(leitor_id) references leitores(leitor_id) on delete cascade,
    foreign key(obra_id) references obras(obra_id) on delete cascade,
    foreign key(func_prontuario) references funcionario(func_prontuario) on delete cascade
);

create sequence reserva_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;


create table emprestimo(
    emp_id number(6) primary key,
    emp_data date not null,
    emp_data_real_dev date,
    emp_data_prev_dev date not null,
    exemplar_id number not null,
    leitor_id number(6) not null,
    func_prontuario varchar(20) not null,
    
    foreign key(leitor_id) references leitores(leitor_id) on delete cascade,
    foreign key(exemplar_id) references exemplar(exemplar_id) on delete cascade,
    foreign key(func_prontuario) references funcionario(func_prontuario) on delete cascade
);

create sequence emprestimo_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

create table mensagens_log(
    log_id number primary key,
    mensagem varchar2(256) not null
);
create sequence log_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

-------------------

-- TRIGGERS

/* ATUALIZA O STATUS DO EXEMPLAR APÓS O EMPRÉSTIMO */
create or replace trigger atualiza_status
    after insert on emprestimo
    for each row
declare
    
begin
    case
        when inserting then
            update exemplar
            set exemplar_status = 'Indisponivel'
            where exemplar_id = :NEW.exemplar_id;
    end case;
end;
/