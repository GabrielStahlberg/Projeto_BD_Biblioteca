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


-- Inserir em Categoria_obra

insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('TR', 'Terror');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('CT_FADAS', 'Conto de Fadas');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('CURIO', 'Curiosidades');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('PROG', 'Programação');
insert into categoria_obra(cat_obra_cod, cat_obra_desc) values('BD', 'Banco de Dados');

-- Inserir em Leitor

insert into leitor
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1710111', 'Gabriel', 'SP', '11.111.111-1', 'SP', 'Araraquara', 'Rua Um, 1, Jardim Primeiro', 'ga@gmail.com',
'(16)11111111', 1, '02/09/1998', 'ALU_TEC_GRAD');

insert into leitor
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1711222', 'Marcos', 'SP', '22.222.222-2', 'SP', 'Rincão', 'Rua Dois, 2, Jardim Secundo', 'ma@gmail.com',
'(16)22222222', 1, '21/04/1998', 'ALU_POS');

insert into leitor
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1713333', 'Dênis', 'SC', '33.333.333-3', 'SC', 'Florianópolis', 'Rua Três, 3, Jardim Terceiro', 'de@ifsp.edu.br',
'(16)33333333', 1, '11/06/1985', 'PROF');

insert into leitor
(leitor_id, leitor_prontuario, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, '1714421', 'João', 'RJ', '44.444.444-4', 'RJ', 'Niteroi', 'Rua Quatro, 4, Jardim Quarto', 'jo@ifsp.edu.br',
'(16)44448757', 1, '13/08/1992', 'FUNC');

insert into leitor
(leitor_id, leitor_nome, leitor_rg_estado, leitor_rg, leitor_uf, leitor_cidade, leitor_endereco, leitor_email, 
leitor_telefone, leitor_status_emprestimo, leitor_data_nasc, cat_leitor_cod)
values(leitor_seq.nextval, 'Joana', 'MG', '55.555.555-5', 'MG', 'Belo Horizonte', 'Rua Cinco, 5, Jardim Quinto', 'joa@ifsp.edu.br',
'(16)58742255', 1, '28/09/1990', 'USR_EXT');

-- Inserir em obra

insert into obra(obra_id, obra_isbn, obra_palavra_chave, obra_autor, obra_editora, obra_titulo, obra_num_edicao, obra_qtde_total, cat_obra_cod)
values(obra_seq.nextval, );