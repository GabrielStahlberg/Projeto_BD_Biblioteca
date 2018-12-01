set serveroutput on

create or replace package relatorio as
    procedure obras_emprestadas;
    procedure obras_atrasadas;
    --procedure obras_reservadas;
    procedure historico_leitor(p_leitor_id number);
    /*procedure consulta_obra(p_obra_id number);*/
    
    invalid_id exception;
end relatorio;
/


---------------------------------------------------

create or replace package procedimento as
    procedure efetuar_emprestimo(p_leitor_id number, p_pront_func varchar, p_exemplar_id number);
    /*procedure efetuar_reserva(p_obra_id, p_leitor_id, p_pront_func);*/
    procedure efetuar_devolucao(p_exemplar_id number);

    invalid_id exception;
    
    function verifica_funcionario(p_pront_func varchar) return boolean;
    function verifica_disponibilidade(p_exemplar_id number) return boolean;
    
    /*function verifica_obra(p_obra_id number) return boolean;
    function verifica_funcionario(p_pront_func number) return boolean;
    function verifica_leitor(p_leitor_id number) return boolean;*/
end procedimento;
/


