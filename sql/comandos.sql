// Inserir novo colaborador

SELECT * FROM BRH.COLABORADOR;

INSERT INTO BRH.COLABORADOR (MATRICULA, CPF, NOME, SALARIO, DEPARTAMENTO, CEP, LOGRADOURO, COMPLEMENTO_ENDERECO)
VALUES
('A666','381.121.298-71','Fulano de Tal','10500', 'DEPTI', '01153-000', 'Rua Vitorino Carmilo', '830');

SELECT * FROM BRH.PAPEL;

INSERT INTO BRH.PAPEL (ID, NOME)
VALUES
('8', 'Especialista de Neg�cios')

SELECT * FROM BRH.PROJETO;

INSERT INTO BRH.PROJETO (ID, NOME, RESPONSAVEL, INICIO, FIM)
VALUES
('9', 'BI', 'A666', '01/01/2024', '01/06/2024')

SELECT * FROM BRH.ATRIBUICAO;

INSERT INTO BRH.ATRIBUICAO (COLABORADOR, PROJETO, PAPEL)
VALUES
('A666','381.121.298-71','Fulano de Tal','10500', 'DEPTI', '01153-000', 'Rua Vitorino Carmilo', '830');

SELECT * FROM BRH.ENDERECO;

INSERT INTO BRH.ENDERECO (CEP, UF, CIDADE, BAIRRO)
VALUES
('01153-000','SP','S�o Paulo','Barra Funda');

SELECT * FROM BRH.TELEFONE_COLABORADOR;

INSERT INTO BRH.TELEFONE_COLABORADOR (NUMERO, COLABORADOR, TIPO)
VALUES
('(61) 9 9999-9999','A666','M');

INSERT INTO BRH.TELEFONE_COLABORADOR (NUMERO, COLABORADOR, TIPO)
VALUES
('(61) 3030-4040','A666','R');

SELECT * FROM BRH.EMAIL_COLABORADOR;

INSERT INTO BRH.EMAIL_COLABORADOR (EMAIL, COLABORADOR, TIPO)
VALUES
('fulano@email.com','A666','P');

INSERT INTO BRH.EMAIL_COLABORADOR (EMAIL, COLABORADOR, TIPO)
VALUES
('fulano.tal@brh.com','A666','T');

SELECT * FROM BRH.DEPENDENTE;

INSERT INTO BRH.DEPENDENTE (CPF, NOME, DATA_NASCIMENTO, PARENTESCO, COLABORADOR)
VALUES
('365.365.598-91','Beltrana de Tal','01/01/1987','Filho(a)', 'A666');

INSERT INTO BRH.DEPENDENTE (CPF, NOME, DATA_NASCIMENTO, PARENTESCO, COLABORADOR)
VALUES
('365.315.598-91','Cicrana de Tal','01/01/1955','Cônjuge', 'A666');

// Relat�rio de departamentos

SELECT SIGLA, NOME FROM BRH.DEPARTAMENTO;

// Relat�rio de dependentes

SELECT NOME FROM BRH.COLABORADOR; 
SELECT NOME FROM BRH.DEPENDENTE;
SELECT DATA_NASCIMENTO FROM BRH.DEPENDENTE;
SELECT PARENTESCO FROM BRH.DEPENDENTE;

SELECT C.nome AS "NOME DO COLABORADOR", D.nome AS "NOME DO DEPENDENTE",
D.data_nascimento AS "DATA DE NASCIMENTO DO DEPENDENTE", D.parentesco  
FROM BRH.COLABORADOR C JOIN BRH.DEPENDENTE D ON  D.COLABORADOR = C.MATRICULA;

// Excluir departamento SECAP 

SELECT * FROM BRH.DEPARTAMENTO;
DELETE FROM BRH.DEPARTAMENTO WHERE SIGLA = 'SECAP';

// Relat�rio de contatos

SELECT C.nome AS "NOME DO COLABORADOR", E.Email AS "EMAIL COORPORATIVO", T.numero
AS "CELULAR" FROM BRH.COLABORADOR C 
JOIN BRH.EMAIL_COLABORADOR E ON  E.COLABORADOR = C.MATRICULA AND E.TIPO = 'T'
JOIN BRH.TELEFONE_COLABORADOR T ON T.COLABORADOR = C.MATRICULA AND T.TIPO = 'M'
ORDER BY (C.NOME);



// SEMANA 3 
// Filtrar dependentes

CREATE VIEW VW_DEPENDENTES AS
SELECT C.NOME AS COLABORADOR, D.NOME AS DEPENDENTE, D.DATA_NASCIMENTO
FROM BRH.DEPENDENTE D INNER JOIN BRH.COLABORADOR C
ON C.MATRICULA = D.COLABORADOR;

SELECT * FROM VW_DEPENDENTES

SELECT COLABORADOR, DEPENDENTE, DATA_NASCIMENTO FROM VW_DEPENDENTES
WHERE (extract(month from data_nascimento)>=4 and extract(month from data_nascimento)<=6)
OR UPPER(DEPENDENTE) like '%h%';

SELECT COLABORADOR, DEPENDENTE, DATA_NASCIMENTO FROM VW_DEPENDENTES 
WHERE (extract(month from data_nascimento))>=4 and extract(month from data_nascimento)<=6;


//Listar colaborador com maior sal�rio

SELECT NOME, SALARIO FROM BRH.COLABORADOR
WHERE SALARIO >= 49944
order by salario desc;

// Relat�rio de senioridade

SELECT
    MATRICULA,
    NOME,
    SALARIO,
    CASE
        WHEN SALARIO <= 3000 THEN 'JR'
        WHEN SALARIO > 3000 AND SALARIO <= 6000 THEN 'PL'
        WHEN SALARIO > 6000 AND SALARIO <= 20000 THEN 'SR'
        ELSE 'CORPO DIRETOR'
    END AS CORPO_DIRETOR
FROM BRH.COLABORADOR
ORDER BY COLABORADOR.SALARIO DESC;

// Listar colaboradores em projetos

SELECT * FROM BRH.DEPARTAMENTO;

SELECT * FROM BRH.PROJETO;

SELECT COUNT(NOME) FROM BRH.DEPARTAMENTO; 

SELECT 
BRH.D.NOME AS DEPARTAMENTO,
BRH.P.NOME AS PROJETO,
    COUNT(brh.c.nome) AS QUANTIDADE_COLABORADORES
    FROM 
    BRH.DEPARTAMENTO D
    INNER JOIN
    BRH.COLABORADOR C ON brh.D.SIGLA = brh.C.DEPARTAMENTO
    INNER JOIN
    BRH.ATRIBUICAO A ON brh.C.MATRICULA = brh.A.COLABORADOR
    INNER JOIN
    BRH.PROJETO P ON brh.A.PROJETO = brh.P.ID
GROUP BY D.NOME, P.NOME
ORDER BY D.NOME



// Listar colaboradores com mais dependentes

SELECT * FROM BRH.COLABORADOR;
SELECT * FROM BRH.DEPENDENTE;
SELECT  C.NOME, COUNT(D.CPF)
    FROM BRH.COLABORADOR C
    INNER JOIN BRH.DEPENDENTE D
    ON C.MATRICULA = D.COLABORADOR
    GROUP BY C.NOME
    HAVING COUNT(D.CPF) >= 2
ORDER BY COUNT(D.CPF) DESC, C.NOME

// Listar faixa et�ria dos dependentes

SELECT
CPF, NOME, DATA_NASCIMENTO, PARENTESCO,
COLABORADOR,
TRUNC(MONTHS_BETWEEN(SYSDATE, DATA_NASCIMENTO)/12) AS IDADE_ATUAL,
CASE
WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, DATA_NASCIMENTO)/12) < 18 THEN 'MENOR DE IDADE'
ELSE 'MAIOR DE IDADE'
END AS IDADES
FROM BRH.DEPENDENTE D
ORDER BY COLABORADOR, NOME;

// Paginar listagem de colaboradores

SELECT ROWNUM AS NUM_LINHA, NOME
FROM BRH.COLABORADOR
ORDER BY NOME
FETCH FIRST 10 ROWS ONLY; --

SELECT ROWNUM AS NUM_LINHA, NOME
FROM BRH.COLABORADOR
ORDER BY NOME
OFFSET 10 ROWS --
FETCH NEXT 10 ROWS ONLY;

SELECT ROWNUM AS NUM_LINHA, NOME
FROM BRH.COLABORADOR
ORDER BY NOME
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;

commit;
