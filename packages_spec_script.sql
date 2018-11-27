create or replace package relatorio as
    procedure obras_emprestadas;
    procedure obras_atrasadas;
    procedure obras_reservadas;
    procedure historico_leitor(p_leitor_id number);
    procedure consulta_obra(p_obra_id number);
    
    invalid_id exception;
end relatorio;
/

create or replace package procedimento as
	procedure efetuar_reserva(p_obra_id, p_leitor_id, p_pront_func);
	procedure efetuar_emprestimo;
	procedure efetuar_devolucao;

	invalid_id exception;

	function verifica_obra(p_obra_id number) return number;
	function verifica_funcionario(p_pront_func number) return number;
	function verifica_leitor(p_leitor_id number) return number;
end procedimento;
/