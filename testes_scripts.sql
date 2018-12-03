begin
    procedimento.efetuar_emprestimo(10, '2010301', 3);
end;
/

begin
    procedimento.efetuar_reserva(1, 10, '2010301');
end;
/

begin
    procedimento.efetuar_devolucao(3);
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