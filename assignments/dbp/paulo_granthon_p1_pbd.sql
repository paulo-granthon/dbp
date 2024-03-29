/*
    Paulo Granthon - 3ºBD
*/

/*
    1 -
    Liste os CDs que possuem
    - a data de lançamento maior que 01/06/2014 e o
    - preço de venda maior que 30.50
    ordenados pelo nome.
    Exiba: (cd_nome,cd_preco_venda,cd_data_lançamento).
*/
SELECT cd_nome, cd_preco_venda, cd_data_lançamento
FROM CD
WHERE cd_preco_venda > 30.50
ORDER BY cd_nome;

/*
    2 -
    Liste todas as gravadoras e os seus CDS,
    liste até mesmo as que não possuem CDs relacionados.
    Exiba: (grav_nome,cd_nome).
    Resolva utilizando a Sintaxe Ansi e a da Oracle.
*/
-- ANSI
SELECT gr.grav_nome, cd.cd_nome
FROM GRAVADORA gr
JOIN CD cd ON cd.grav_codigo = gr.grav_codigo;
-- ORACLE
SELECT gr.grav_nome, cd.cd_nome
FROM GRAVADORA gr, CD cd
WHERE cd.grav_codigo = gr.grav_codigo(+);

/*
    3 -
    Exibir a quantidade de músicas que cada autor possui.
    Exiba: Aut_Nome,Quantidade.
*/
SELECT au.aut_nome, COUNT(am.aut_codigo) as quantidade
FROM AUTOR au
LEFT JOIN AUTOR_MUSICA am on am.aut_codigo = au.aut_codigo;


/*
    4 -
    Exiba o nome do CD mais caro
*/
SELECT cd_nome
FROM CD
ORDER BY cd_preco DESC
LIMIT 1;

/*
    5 -
    Listar o nome do autor responsável pela música Pais e Filhos.
*/
SELECT au.auth_nome
FROM AUTOR au
WHERE au.auth_codigo = (
    SELECT am.auth_codigo
    FROM AUTOR_MUSICA am
    WHERE am.mus_codigo = (
        SELECT m.mus_codigo
        FROM MUSICA
        WHERE m.mus_nome = 'Pais e Filhos'
    )
);

/*
    6 -
    Exiba a duração correspondente ao código do CD de código 1.
*/
SELECT SUM(m.mus_duracao) as duracao
FROM MUSICA m
WHERE m.mus_codigo IN (
    SELECT f.mus_codigo
    FROM FAIXA f
    WHERE f.cd_codigo = 1
);

/*
    7 -
    Crie as tabelas, usando DDL, do modelo lógico a seguir
*/
CREATE TABLE Partido (
    idPartido           NUMBER(4) PRIMARY KEY,
    siglaPartido        NUMBER(4),
    descricaoPartido    VARCHAR(30)
);

CREATE TABLE Deputado (
    idDeputado          NUMBER(4) PRIMARY KEY,
    idPartido           NUMBER(4) NOT NULL,
    nomeDeputado        VARCHAR(30),
    FOREIGN KEY (idPartido) REFERENCES Partido(idPartido)
);


CREATE TABLE Sessao (
    idSessao            NUMBER(4) PRIMARY KEY,
    dataSessao          DATE,
    horaSessao          VARCHAR(4),
    decisao             VARCHAR(4)
);

CREATE TABLE Participacao (
    idSessao            NUMBER(4) NOT NULL,
    idDeputado          NUMBER(4) NOT NULL,
    PRIMARY KEY (idSessao, idDeputado)
)
