create or replace package relatorio as
    procedure obras_emprestadas;
    procedure obras_atrasadas;
    procedure obras_reservadas;
    procedure historico_leitor(p_leitor_id number);
    procedure consulta_obra(p_obra_id number);
    invalid_id exception;
end relatorio;
/