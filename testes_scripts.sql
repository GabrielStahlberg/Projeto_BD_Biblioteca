select * from exemplar;
select * from obras;
select * from leitores;
select * from reserva;
select * from emprestimo;
select * from mensagens_log;
select * from funcionario;

------------------------------------

drop sequence autores_seq;
drop sequence emprestimo_seq;
drop sequence exemplar_seq;
drop sequence leitor_seq;
drop sequence obra_seq;
drop sequence palavras_chave_seq;
drop sequence reserva_seq;

------------------------------------

-- Sequência possível para dropar tables

RESERVA
PALAVRAS_CHAVE
AUTORES
EMPRESTIMO
FUNCIONARIO
EXEMPLAR
OBRAS
LEITORES
CATEGORIA_LEITOR
CATEGORIA_OBRA

------------------------------------

begin
    procedimento.efetuar_emprestimo(20, '2010301', 999);
end;
/

begin
    procedimento.efetuar_reserva(1, 30, '2010301');
end;
/

begin
    procedimento.efetuar_devolucao(1);
end;
/

begin
    relatorio.obras_emprestadas;
end;
/

begin
    relatorio.obras_atrasadas;
end;
/

begin
    relatorio.obras_reservadas;
end;
/

begin
    relatorio.historico_leitor(10);
end;
/

begin
    relatorio.consulta_obra(1);
end;
/