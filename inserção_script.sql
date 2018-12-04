-- Inserir em Categoria_leitor

insert into categoria_leitor(cat_leitor_cod, cat_leitor_desc, cat_leitor_max_dias)
values ('ALU_TEC_GRAD', 'Aluno de curso técnico e de graduação', 15);

insert into categoria_leitor(cat_leitor_cod, cat_leitor_desc, cat_leitor_max_dias)
values ('ALU_POS', 'Aluno de pós-graduação', 30);

insert into categoria_leitor(cat_leitor_cod, cat_leitor_desc, cat_leitor_max_dias)
values ('PROF', 'Professor', 30);

insert into categoria_leitor(cat_leitor_cod, cat_leitor_desc, cat_leitor_max_dias)
values ('FUNC', 'Funcionário', 30);

insert into categoria_leitor(cat_leitor_cod, cat_leitor_desc, cat_leitor_max_dias)
values ('USR_EXT', 'Usuário externo', 7);

-- Inserir em Leitor

insert into leitores
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1710111', 'Gabriel', 'SP', '11.111.111-1', 'SP', 'Araraquara', 'Rua Um, 1, Jardim Primeiro', 'ga@gmail.com',
'(16)11111111', 1, '02/09/1998', 'ALU_TEC_GRAD');

insert into leitores
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1711222', 'Marcos', 'SP', '22.222.222-2', 'SP', 'Rincão', 'Rua Dois, 2, Jardim Secundo', 'ma@gmail.com',
'(16)22222222', 1, '21/04/1998', 'ALU_POS');

insert into leitores
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1713333', 'Dênis', 'SC', '33.333.333-3', 'SC', 'Florianópolis', 'Rua Três, 3, Jardim Terceiro', 'de@ifsp.edu.br',
'(16)33333333', 1, '11/06/1985', 'PROF');

insert into leitores
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1714421', 'João', 'RJ', '44.444.444-4', 'RJ', 'Niteroi', 'Rua Quatro, 4, Jardim Quarto', 'jo@ifsp.edu.br',
'(16)44448757', 1, '13/08/1992', 'FUNC');

insert into leitores
(leitor_id, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, 'Joana', 'MG', '55.555.555-5', 'MG', 'Belo Horizonte', 'Rua Cinco, 5, Jardim Quinto', 'joa@ifsp.edu.br',
'(16)58742255', 1, '28/09/1990', 'USR_EXT');


-- Inserir em Categoria_obra

insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('ROMANC', 'Romance');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('CT_FADAS', 'Conto de Fadas');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('CURIO', 'Curiosidades');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('PROG', 'Programação');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('BD', 'Banco de Dados');

-- Inserir em palavras_chave

insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'romance', '147-74-147-0554-1');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'fada', '258-85-258-8888-2');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'conto', '258-85-258-8888-2');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'curiosidades', '369-96-369-9999-3');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'guia', '369-96-369-9999-3');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'programação', '985-58-558-0000-8');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'logica', '985-58-558-0000-8');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'banco', '020-11-332-2012-0');
insert into palavras_chave(palavra_id, palavra, obra_isbn)values(PALAVRAS_CHAVE_SEQ.nextval, 'dados', '020-11-332-2012-0');

-- Inserir em autores

insert into autores(autor_nro, autor_nome, obra_isbn)values(autores_seq.nextval, 'Miguel de Cervantes', '147-74-147-0554-1');
insert into autores(autor_nro, autor_nome, obra_isbn)values(autores_seq.nextval, 'Charles Perrault', '258-85-258-8888-2');
insert into autores(autor_nro, autor_nome, obra_isbn)values(autores_seq.nextval, 'Marcelo Duarte', '369-96-369-9999-3');
insert into autores(autor_nro, autor_nome, obra_isbn)values(autores_seq.nextval, 'Marcelo Gomes', '985-58-558-0000-8');
insert into autores(autor_nro, autor_nome, obra_isbn)values(autores_seq.nextval, 'Ricardo Concilio', '985-58-558-0000-8');
insert into autores(autor_nro, autor_nome, obra_isbn)values(autores_seq.nextval, 'Carlos A. Heuser', '020-11-332-2012-0');

-- Inserir em obra

insert into obras(obra_id, obra_isbn, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod)
values(obra_seq.nextval, '147-74-147-0554-1', 'Francisco de Robles', 'Dom Quixote', 102, 10, 'ROMANC');

insert into obras(obra_id, obra_isbn, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod)
values(obra_seq.nextval, '258-85-258-8888-2', 'Ática', 'O Pequeno Polegar', 201, 10, 'CT_FADAS');

insert into obras(obra_id, obra_isbn, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod)
values(obra_seq.nextval, '369-96-369-9999-3', 'CIA das Letras', 'O guia dos curiosos', 505, 10, 'CURIO');

insert into obras(obra_id, obra_isbn, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod)
values(obra_seq.nextval, '985-58-558-0000-8', 'CENGAGE Learning', 'Algotirmos e lógica de programação', 404, 10, 'PROG');

insert into obras(obra_id, obra_isbn, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod)
values(obra_seq.nextval, '020-11-332-2012-0', 'BooksMark', 'Projeto de Banco de Dados', 999, 10, 'BD');

-- Inserir em exemplar

insert into exemplar(exemplar_id, obra_id) values(exemplar_seq.nextval, 1);
insert into exemplar(exemplar_id, obra_id) values(exemplar_seq.nextval, 2);
insert into exemplar(exemplar_id, obra_id) values(exemplar_seq.nextval, 3);
insert into exemplar(exemplar_id, obra_id) values(exemplar_seq.nextval, 4);
insert into exemplar(exemplar_id, obra_id) values(exemplar_seq.nextval, 5);

-- Inserção em funcionário

insert into funcionario(func_prontuario, func_endereco, func_nome, func_data_nasc, func_telefone) values('2010301', 'Av. Brasil, 122, Centro', 'Roberto da Silva', '05/08/1990', '(16)33391221');
insert into funcionario(func_prontuario, func_endereco, func_nome, func_data_nasc, func_telefone) values('2154488', 'Av. Alemanha, 133, Vila Berlim', 'Adolf Ballack', '15/02/1992', '(15)33218855');
insert into funcionario(func_prontuario, func_endereco, func_nome, func_data_nasc, func_telefone) values('3005568', 'Av. Canada, 555, Jardim Vancouver', 'John Smith', '29/11/1991', '(12)59875562');
insert into funcionario(func_prontuario, func_endereco, func_nome, func_data_nasc, func_telefone) values('2144558', 'Av. Australia, 54, Residencial Sidney', 'James Green', '30/09/1989', '(14)22554154');
insert into funcionario(func_prontuario, func_endereco, func_nome, func_data_nasc, func_telefone) values('2259636', 'Av. Japao, 999, Vila Tokio', 'Kim Nakamura', '01/01/1992', '(18)99963565');
