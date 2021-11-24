CREATE DATABASE PROJETO;

USE PROJETO;

SHOW TABLES;

CREATE TABLE CLIENTE(
	NOME VARCHAR(30),
	SEXO CHAR(1),
	EMAIL VARCHAR(30),
	CPF INT(11),
	TELEFONE VARCHAR(30),
	ENDERECO VARCHAR(100)
);

INSERT INTO CLIENTE VALUES('JOAO','M','JOAO@GMAIL.COM',983545849,'22923110','MAIA LACERDA - ESTACIO - RIO DE JANEIRO - RJ');
INSERT INTO CLIENTE VALUES('CELIA','F','CELIA@GMAIL.COM',549874515,'55130552','RIACHUELO - CENTRO - RIO DE JANEIRO - RJ');
INSERT INTO CLIENTE VALUES('JORGE','M','NULL',859745698,'22945521','OSCAR CURY - BOM RETIRO - PATO DE MINAS - MG');

INSERT INTO CLIENTE(NOME,SEXO,ENDERECO,TELEFONE,CPF) VALUES('LILIAN','F','SENADOR SOARES - TIJUCA - RIO DE JANEIRO - RJ','987452588',887456587);

INSERT INTO CLIENTE VALUES('ANA','F','ANA@GLOBO.COM',85548962,'548556985','PRES ANTONIO CARLOS - CENTRO - SAO PAULO - SP'),
                          ('CARLA','F','CARLA@TERATI.COM.BR',7745828,'66587458','SAMUEL SILVA - CENTRO - BELO HORIZONTE - MG');
		


SELECT NOME,ENDERECO,TELEFONE FROM CLIENTE WHERE SEXO='M';

/* LIKE TRABALHA COM CARACTER CORINGA % */

SELECT NOME,SEXO FROM CLIENTE WHERE ENDERECO LIKE '%RJ';
SELECT NOME,SEXO,ENDERECO FROM CLIENTE WHERE ENDERECO LIKE '%CENTRO%';
SELECT NOME,SEXO,ENDERECO FROM CLIENTE WHERE SEXO='M' OR ENDERECO LIKE '%RJ';
SELECT NOME,SEXO,ENDERECO FROM CLIENTE WHERE SEXO='F' OR ENDERECO LIKE '%ESTACIO%';
SELECT NOME,SEXO,ENDERECO FROM CLIENTE WHERE SEXO='M' AND ENDERECO LIKE '%RJ';
SELECT NOME,SEXO,ENDERECO FROM CLIENTE WHERE SEXO='F' AND ENDERECO LIKE '%ESTACIO%';

SELECT COUNT(*) FROM CLIENTE;
SELECT COUNT(*) AS QUANTIDADE FROM CLIENTE;

SELECT SEXO, COUNT(*) AS QUANTIDADE
FROM CLIENTE
GROUP BY SEXO;

SELECT NOME,ENDERECO,TELEFONE FROM CLIENTE WHERE EMAIL IS NULL;
SELECT NOME,ENDERECO,TELEFONE FROM CLIENTE WHERE EMAIL IS NOT NULL;

UPDATE CLIENTE
SET EMAIL='LILIAN@HOTMAIL.COM'
WHERE NOME='LILIAN';

UPDATE CLIENTE
SET EMAIL='JORGE@HOTMAIL.COM'
WHERE NOME='JORGE';

DELETE FROM CLIENTE 
WHERE NOME='ANA';

SELECT NOME, SEXO ,ENDERECO
FROM CLIENTE
WHERE SEXO ="F" AND (ENDERECO LIKE "%RJ" OR ENDERECO LIKE "%SP");

SELECT SEXO, COUNT(*)
FROM CLIENTE
GROUP BY SEXO;

SELECT * FROM FUNCIONARIOS
WHERE DEPARTAMENTO = "Filmes" OR DEPARTAMENTO = "Roupas";

SELECT NOME, EMAIL, SEXO, DEPARTAMENTO, CARGO
FROM FUNCIONARIOS
WHERE SEXO = "FEMININO" AND (DEPARTAMENTO = "Filmes" OR DEPARTAMENTO= "Roupas");

SELECT NOME, EMAIL, SEXO, DEPARTAMENTO, CARGO
FROM FUNCIONARIOS
WHERE SEXO = "Masculino" OR DEPARTAMENTO = "Jardim";