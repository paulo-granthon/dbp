/*
	1 - Listar o nome da pessoa do empréstimo de número 1
*/
select p.pes_nome
from pessoa p, emprestimo e
where p.pes_cod = e.pes_cod and e.emp_cod = 1

/*
	2 - Listar todas as editoras ordenadas por ordem alfabética.
*/
select *
from editora
order by edi_descricao

/*
	3 - Exibir os títulos dos livros que começam com a letra A.
*/
select liv_titulo
from livro
where liv_titulo like 'A%'

/*
	4 - Exibir os títulos dos livros que começam com a letra A e que tenham o ano de publicação maior que 2013.
*/
select liv_titulo
from livro
where anopublicacao > 2013 and liv_titulo like 'A%'

/*
	5 - Exibir a quantidade de telefones que possuem DDD igual a 12.
*/
select count(*)
from telefone
where tel_ddd = 12

/*
	6 - Listar a quantidade de empréstimo por aluno. (exiba: - pes_nro_matricula e - quantidade).
*/
select a.pes_nro_matricula, count(emp_cod) as "QUANTIDADE DE EMPRÉSTIMO"
from aluno a, pessoa p, emprestimo e
where a.pes_cod = p.pes_cod and p.pes_cod=e.pes_cod
group by a.pes_nro_matricula

/*
	7 - Listar as editoras e os seus livros. (exiba: - edi_cod,edi_descricao, - liv_cod).
*/
select ed.edi_cod, ed.edi_descricao, l.liv_cod
from editora ed, livro l
where ed.edi_cod = l.edi_cod

/*
	8 - Listar os códigos dos exemplares (exe_cod), a descrição (exe_descricao) do empréstimo realizado em uma determinada data.
*/
SELECT ie.exe_cod, e.exe_descricao
FROM item_emprestimo ie
JOIN exemplar e ON ie.exe_cod = e.exe_cod
JOIN emprestimo em ON ie.emp_cod = em.emp_cod
WHERE em.emp_data_emprestimo = TO_DATE('10/10/2015', 'dd/mm/yyyy');

/*
	9 - Listar os livros que possuam mais de 3 exemplares.
*/
SELECT l.liv_cod, l.liv_titulo
FROM livro l
WHERE l.liv_cod IN (
    SELECT e.liv_cod
    FROM exemplar e
    GROUP BY e.liv_cod
    HAVING COUNT(*) > 3
);

/*	10 - Listar os professores (nome e titulação) com seus respectivos telefones.
    OBS: Listar também os professores que não tenham telefone.
    Realizar duas resoluções uma com a sintaxe ANSI e outra com a sintaxe ORACLE.
*/
-- Sintaxe ANSI
SELECT p.pes_nome, pr.titulacao, t.tel_numero
FROM professor pr
LEFT JOIN pessoa p ON pr.pes_cod = p.pes_cod
LEFT JOIN telefone t ON p.pes_cod = t.pes_cod;

-- Sintaxe ORACLE
SELECT p.pes_nome, pr.titulacao, t.tel_numero
FROM professor pr, pessoa p, telefone t
WHERE pr.pes_cod = p.pes_cod(+) AND p.pes_cod = t.pes_cod(+);

/*
	11 - Listar o livro (liv_titulo) mais antigo da biblioteca
*/
SELECT liv_titulo
FROM livro
WHERE anopublicacao = (SELECT MIN(anopublicacao) FROM livro);

/*
	12 - Exibir o nome da pessoa que mais emprestou livro na biblioteca.
*/
SELECT p.pes_nome
FROM pessoa p
WHERE p.pes_cod = (
    SELECT e.pes_cod
    FROM emprestimo e
    GROUP BY e.pes_cod
    HAVING COUNT(*) = (
        SELECT MAX(emp_count)
        FROM (
            SELECT COUNT(*) AS emp_count
            FROM emprestimo
            GROUP BY pes_cod
        )
    )
);

/*
	13 - Listar a quantidade de exemplares por livro.
*/
SELECT l.liv_cod, l.liv_titulo, COUNT(e.exe_cod) AS "QUANTIDADE DE EXEMPLARES"
FROM livro l
LEFT JOIN exemplar e ON l.liv_cod = e.liv_cod
GROUP BY l.liv_cod, l.liv_titulo;

/*
	14 - Listar os livros (liv_titulo) que começam com A e possuem ano de publicação maior que 2011.
*/
SELECT liv_titulo
FROM livro
WHERE liv_titulo LIKE 'A%' AND anopublicacao > '2011';

/*
	15 - Listar os livros emprestados pela pessoa de código 1 (Listar liv_titulo)
*/
SELECT DISTINCT l.liv_titulo
FROM livro l
JOIN exemplar e ON l.liv_cod = e.liv_cod
JOIN item_emprestimo ie ON e.exe_cod = ie.exe_cod
JOIN emprestimo em ON ie.emp_cod = em.emp_cod
WHERE em.pes_cod = 1;

/*
	16 - Criar mais 4 consultas (Perguntas e Respostas).
*/
-- Pergunta 1: Listar as pessoas que não possuem telefone.
SELECT pes_cod, pes_nome
FROM pessoa
WHERE pes_cod NOT IN (SELECT pes_cod FROM telefone);

-- Pergunta 2: Listar os empréstimos atrasados, ou seja, onde a data de devolução prevista (emp_data_PrevDev) é anterior à data atual.
SELECT emp_cod, emp_data_emprestimo, emp_data_PrevDev
FROM emprestimo
WHERE emp_data_PrevDev < SYSDATE;

-- Pergunta 3: Listar os professores que também são alunos.
SELECT DISTINCT p1.pes_cod, p1.pes_nome
FROM pessoa p1
JOIN professor pr ON p1.pes_cod = pr.pes_cod
JOIN aluno a ON p1.pes_cod = a.pes_cod;

-- Pergunta 4: Listar os exemplares que estão emprestados no momento (não devolvidos).
SELECT e.exe_cod, l.liv_titulo
FROM exemplar e
JOIN livro l ON e.liv_cod = l.liv_cod
WHERE e.exe_cod NOT IN (SELECT exe_cod FROM devolucao);
