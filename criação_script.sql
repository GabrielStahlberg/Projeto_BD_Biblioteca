--user:  admin_biblioteca
--senha: admin123

create table leitor(
    leitor_id number(6) primary key,
    leitor_prontuario varchar(20),            -- Ou deixar um valor default, caso seja usuário externo e não tenha o prontuário.
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
    cat_leitor_cod varchar(10) not null,
    
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

create table categoria_leitor(
    cat_leitor_cod varchar(15) primary key,
    cat_leitor_desc varchar(256) not null,
    cat_leitor_max_dias number(2) not null,

    constraint dias_check check(cat_leitor_max_dias > 6)
);

create table categoria_obra(
    cat_obra_cod varchar(10) primary key,
    cat_obra_desc varchar(256) not null
);

create table obra(
    obra_id number(6) primary key,
    obra_isbn varchar(20) not null,
    obra_palavra_chave varchar(20),
    obra_autor varchar(50) not null,
    obra_editora varchar(50) not null,
    obra_titulo varchar(50) not null,
    obra_num_edicao number,
    obra_qtde_total number not null,
    cat_obra_cod varchar(10) not null,
    
    constraint cat_obra_fk foreign key(cat_obra_cod) references categoria_obra(cat_obra_cod) on delete cascade
);

create sequence obra_seq
increment by 1
start with 1
maxvalue 100000
nocache
nocycle;

create table exemplar(
    exemplar_id number primary key,
    exemplar_status varchar(20) default 'Disponível',
    obra_id number(6) not null,
    
    constraint obra_id_fk foreign key(obra_id) references obra(obra_id) on delete cascade
);

