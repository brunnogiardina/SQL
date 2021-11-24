USE EMPRESA
GO

CREATE TABLE TB_ALUNO(
	IDALUNO INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL,
	NASCIMENTO DATE NOT NULL,
	EMAIL VARCHAR(30) UNIQUE
)
GO

ALTER TABLE TB_ALUNO
ADD CONSTRAINT CK_SEXO CHECK (SEXO IN('M','F'))
GO

CREATE TABLE TB_ENDERECO(
	IDENDERECO INT PRIMARY KEY IDENTITY(100,10),
	BAIRRO VARCHAR(30),
	UF CHAR(2) NOT NULL
	CHECK (UF IN('RJ','SP','MG')),
	ID_ALUNO INT UNIQUE
)
GO

ALTER TABLE TB_ENDERECO ADD CONSTRAINT FK_TB_ENDERECO_TB_ALUNO
FOREIGN KEY(ID_ALUNO) REFERENCES TB_ALUNO(IDALUNO)
GO

SP_COLUMNS TB_ALUNO
GO

SP_HELP TB_ALUNO
GO

INSERT INTO TB_ALUNO VALUES('ANDRE','M','1981/12/09','ANDRE@IG.COM')
INSERT INTO TB_ALUNO VALUES('ANA','F','1978/03/09','ANA@IG.COM')
INSERT INTO TB_ALUNO VALUES('RUI','M','1951/07/09','RUI@IG.COM')
INSERT INTO TB_ALUNO VALUES('JOAO','M','2002/11/09','JOAO@IG.COM')
GO

SELECT * FROM TB_ALUNO
SELECT * FROM TB_ENDERECO

INSERT INTO TB_ENDERECO VALUES('FLAMENGO','RJ',1)
INSERT INTO TB_ENDERECO VALUES('MORUMBI','SP',2)
INSERT INTO TB_ENDERECO VALUES('CENTRO','MG',4)
INSERT INTO TB_ENDERECO VALUES('CENTRO','SP',3)
GO

CREATE TABLE TB_TELEFONE(
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	ID_ALUNO INT,
	CHECK (TIPO IN ('RES','COM','CEL'))
)
GO

ALTER TABLE TB_TELEFONE ADD CONSTRAINT FK_TB_TELEFONE_TB_ALUNO
FOREIGN KEY(ID_ALUNO) REFERENCES TB_ALUNO(IDALUNO)
GO

INSERT INTO TB_TELEFONE VALUES('CEL','7899889',1)
INSERT INTO TB_TELEFONE VALUES('RES','4325444',1)
INSERT INTO TB_TELEFONE VALUES('COM','4354354',2)
INSERT INTO TB_TELEFONE VALUES('CEL','2344556',2)
GO

SELECT 
	A.NOME, 
	ISNULL(T.TIPO,'SEM'), 
	ISNULL(T.NUMERO,'NUMERO'), 
	E.BAIRRO, 
	E.UF
FROM TB_ALUNO A
LEFT JOIN TB_TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN TB_ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

SELECT NOME, (DATEDIFF(DAY,NASCIMENTO,GETDATE())/365) AS IDADE
FROM TB_ALUNO
GO

SELECT NOME, DATEDIFF(YEAR,NASCIMENTO,GETDATE()) AS IDADE
FROM TB_ALUNO
GO

CREATE TABLE LANCAMENTO_CONTABIL(
	CONTA INT,
	VALOR INT,
	DEB_CRED CHAR(1)
)
GO

BULK INSERT LANCAMENTO_CONTABIL
FROM 'C:\Users\Potato\Documents\CONTAS.txt'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n'

)

select * from LANCAMENTO_CONTABIL

CREATE TABLE PRODUTOS(
	IDPRODUTO INT IDENTITY PRIMARY KEY,
	NOME VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECO NUMERIC(10,2) NOT NULL
)
GO

CREATE TABLE HISTORICO(
	IDOPERACAO INT PRIMARY KEY IDENTITY,
	PRODUTO VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECOANTIGO NUMERIC(10,2) NOT NULL,
	PRECONOVO NUMERIC(10,2) NOT NULL,
	DATA DATETIME,
	USUARIO VARCHAR(30),
	MENSAGEM VARCHAR(100)
)
GO

INSERT INTO PRODUTOS VALUES('LIVRO SQL SERVER','LIVROS',98.00)
INSERT INTO PRODUTOS VALUES('LIVRO ORACLE','LIVROS',50.00)
INSERT INTO PRODUTOS VALUES('LICEN�A POWERCENTER','SOFTWARES',45000.00)
INSERT INTO PRODUTOS VALUES('NOTEBOOK I7','COMPUTADORES',3150.00)
INSERT INTO PRODUTOS VALUES('LIVRO BUSINESS INTELLIGENCE','LIVROS',90.00)
GO

SELECT * FROM PRODUTOS
GO

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE AS
IF UPDATE(PRECO)
BEGIN

		DECLARE @IDPRODUTO INT
		DECLARE @PRODUTO VARCHAR(30)
		DECLARE @CATEGORIA VARCHAR(10)
		DECLARE @PRECO NUMERIC(10,2)
		DECLARE @PRECONOVO NUMERIC(10,2)
		DECLARE @DATA DATETIME
		DECLARE @USUARIO VARCHAR(30)
		DECLARE @ACAO VARCHAR(100)

		--PRIMEIRO BLOCO
		SELECT @IDPRODUTO = IDPRODUTO FROM inserted
		SELECT @PRODUTO = NOME FROM inserted
		SELECT @CATEGORIA = CATEGORIA FROM inserted
		SELECT @PRECO = PRECO FROM deleted
		SELECT @PRECONOVO = PRECO FROM inserted

		--SEGUNDO BLOCO
		SET @DATA = GETDATE()
		SET @USUARIO = SUSER_NAME()
		SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

		INSERT INTO HISTORICO
		(PRODUTO,CATEGORIA,PRECOANTIGO,PRECONOVO,DATA,USUARIO,MENSAGEM)
		VALUES
		(@PRODUTO,@CATEGORIA,@PRECO,@PRECONOVO,@DATA,@USUARIO,@ACAO)

		PRINT 'TRIGGER EXECUTADA COM SUCESSO'
END
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO

UPDATE PRODUTOS SET PRECO = 100.00
WHERE IDPRODUTO =1
GO

CREATE PROC TELEFONES @TIPO CHAR(3)
AS
	SELECT NOME, NUMERO
	FROM PESSOA
	INNER JOIN TELEFONE
	ON IDPESSOA = ID_PESSOA
	WHERE TIPO = @TIPO
GO

EXEC TELEFONES 'COM'
GO

CREATE PROCEDURE GETTIPO @TIPO CHAR(3), @CONTADOR INT OUTPUT
AS
	SELECT @CONTADOR = COUNT(*)
	FROM TELEFONE
	WHERE TIPO = @TIPO
GO

DECLARE @SAIDA INT
EXEC GETTIPO @TIPO = 'CEL', @CONTADOR = @SAIDA OUT
SELECT @SAIDA
GO

CREATE PROC CADASTRO @NOME VARCHAR(30), @SEXO CHAR(1), @NASCIMENTO DATE,
@TIPO CHAR(3), @NUMERO VARCHAR(10)
AS
	DECLARE @FK INT

	INSERT INTO PESSOA VALUES(@NOME,@SEXO,@NASCIMENTO) --GERAR UM ID

	SET @FK = (SELECT IDPESSOA FROM PESSOA WHERE IDPESSOA
	= @@IDENTITY)

	INSERT INTO TELEFONE VALUES(@TIPO,@NUMERO,@FK)
GO

EXEC CADASTRO 'JORGE','M','1981-01-01','CEL','97273822'  
GO

SELECT PESSOA.*, TELEFONE.*
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
GO

SELECT P.IDPESSOA, P.NOME, P.SEXO, P.MASCIMENTO, T.IDTELEFONE, T.TIPO, T.NUMERO, T.ID_PESSOA
FROM PESSOA P
INNER JOIN TELEFONE T
ON IDPESSOA = ID_PESSOA
GO

CREATE TABLE CARROS(
	CARRO VARCHAR(20),
	FABRICANTE VARCHAR(30)
)
GO
INSERT INTO CARROS VALUES('KA','FORD')
INSERT INTO CARROS VALUES('FIESTA','FORD')
INSERT INTO CARROS VALUES('PRISMA','FORD')
INSERT INTO CARROS VALUES('CLIO','RENAULT')
INSERT INTO CARROS VALUES('SANDERO','RENAULT')
INSERT INTO CARROS VALUES('CHEVETE','CHEVROLET')
INSERT INTO CARROS VALUES('OMEGA','CHEVROLET')
INSERT INTO CARROS VALUES('PALIO','FIAT')
INSERT INTO CARROS VALUES('DOBLO','FIAT')
INSERT INTO CARROS VALUES('UNO','FIAT')
INSERT INTO CARROS VALUES('GOL','VOLKSWAGEN')
GO

select * from carros
go

SELECT COUNT(*) FROM CARROS
WHERE FABRICANTE = 'FORD'

DECLARE
		@V_CONT_FORD INT,
		@V_CONT_FIAT INT
BEGIN
		SET @V_CONT_FORD = (SELECT COUNT(*) FROM CARROS
		WHERE FABRICANTE = 'FORD')

		PRINT 'QUANTIDADE FORD: ' + CAST(@V_CONT_FORD AS VARCHAR)

		SELECT @V_CONT_FIAT = COUNT(*) FROM CARROS 
		WHERE FABRICANTE = 'FIAT'

		PRINT 'QUANTIDADE FIAT: ' + CONVERT(VARCHAR,@V_CONT_FIAT)


END
GO

CREATE PROC VERIFICANUMERO @NUMERO INT
AS
	BEGIN
		IF @NUMERO > 5
		PRINT 'VERDADEIRO'

		ELSE
		PRINT 'FALSO'
		
END
GO

EXEC VERIFICANUMERO 6


