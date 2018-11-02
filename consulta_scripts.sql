-- Consultas em categoria_leitor

select * from categoria_leitor;

-- Consultas em categoria_obra

select * from categoria_obra;

-- Consultas em leitor

select * from leitor;

select l.leitor_nome, cl.cat_leitor_max_dias
from categoria_leitor cl
inner join leitor l
on l.cat_leitor_cod = cl.cat_leitor_cod;