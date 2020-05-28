USE master
DROP DATABASE IF EXISTS selects

CREATE DATABASE selects
GO
USE selects
GO
 
CREATE TABLE funcionario(
id          INT             NOT NULL  identity(1,1),
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL  check (numero > 0 and numero < 100000),
bairro      VARCHAR(100)    NULL,
cep         CHAR(8)         NULL       check(len(cep) = 8 ),     
ddd         CHAR(2)         NULL       default('11'),
telefone    CHAR(8)         NULL       check(len(telefone) = 8 ),  
data_nasc   DATETIME        NOT NULL check(data_nasc < getdate()),
salario     DECIMAL(7,2)    NOT NULL   check (salario >0.00)
PRIMARY KEY(id)
)
GO
CREATE TABLE projeto(
codigo      INT             NOT NULL              identity(1001,1),
nome        VARCHAR(200)    NOT NULL                unique,
descricao   VARCHAR(300)    NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario  INT         NOT NULL,
codigo_projeto  INT         NOT NULL,
data_inicio     DATETIME    NOT NULL,
data_fim        DATETIME    NOT NULL,
constraint chk_dt check(data_fim > data_inicio),
PRIMARY KEY (id_funcionario, codigo_projeto),
FOREIGN KEY (id_funcionario) REFERENCES funcionario (id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo))

exec sp_help funcionario

Select len('Banco de dados')

--DBCC CHECKIDENT (nome_tabela, RESEED, novo_valor)
DBCC CHECKIDENT ('funcionario', RESEED, 0)
DBCC CHECKIDENT ('projeto', RESEED, 1001)
 
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, telefone, data_nasc, salario) VALUES
('Fulano',  'da Silva', 'R. Voluntários da Patria',    8150,   'Santana',  '05423110', '76895248', '1974-05-15',   4350.00),
('Cicrano', 'De Souza', 'R. Anhaia', 353,   'Barra Funda',  '03598770', '99568741', '1984-08-25',   1552.00),
('Beltrano',    'Dos Santos',   'R. ABC', 1100, 'Artur Alvim',  '05448000', '25639854', '1963-06-02',   2250.00)
 
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Tirano',  'De Souza', 'Avenida Águia de Haia', 4430, 'Artur Alvim',  '05448000', NULL,   NULL,   '1975-10-15',   2804.00)
 
INSERT INTO projeto VALUES
('Implantação de Sistemas ','Colocar o sistema no ar'),
('Implantação de Sistemas Novos','Colocar o sistema novo no ar'),
('Modificação do módulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)
 
INSERT INTO funcproj VALUES
(1, 1001, '2015-04-18', '2015-04-30'),
(3, 1001, '2015-04-18', '2015-04-30'),
(1, 1002, '2015-05-06', '2015-05-10'),
(2, 1002, '2015-05-06', '2015-05-10'),
(3, 1003, '2015-05-11', '2015-05-13')

--Consultas:
--Select Simples funcionario
SELECT id, nome, sobrenome, logradouro, numero, bairro, salario
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome LIKE '%Silva%'
 
--Select Simples funcionario(s) Souza
SELECT id, nome, sobrenome, logradouro, numero, bairro, salario
FROM funcionario
WHERE sobrenome LIKE '%Souza%'
 
--Id e Nome Concatenado de quem não tem telefone
--NULL (IS NULL || IS NOT NULL)
SELECT id,
        nome+' '+sobrenome AS nome_completo
FROM funcionario
WHERE telefone IS NULL
 
--Id, Nome Concatenado e telefone (sem ddd) de quem tem telefone
SELECT id,
        nome+' '+sobrenome AS nome_completo,
        telefone
FROM funcionario
WHERE telefone IS NOT NULL
ORDER BY nome, sobrenome ASC
--ORDER BY nome_completo DESC
 
--ORDER BY coluna1, coluna2, ... ASC (ou DESC)
 
--Id, Nome Concatenado e telefone (sem ddd)
--de quem tem telefone em ordem alfabética
 
--Id, Nome completo, Endereco completo (Rua, nº e CEP),
--ddd e telefone, ordem alfabética crescente
SELECT id,
        nome+' '+sobrenome AS nome_completo,
        logradouro+','+CAST(numero AS VARCHAR(5))+' - CEP:'+cep AS endereco,
        ddd,
        telefone
FROM funcionario
ORDER BY nome_completo ASC
 
--Nome completo, Endereco completo (Rua, nº e CEP), data_nasc (BR), ordem alfabética decrescente
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        logradouro+','+CAST(numero AS VARCHAR(5))+' - CEP:'+cep AS endereco,
        ddd,
        telefone,
        CONVERT(CHAR(10),data_nasc,103) AS data_nasc
FROM funcionario
ORDER BY nome_completo DESC
 
--Datas distintas (BR) de inicio de trabalhos
-- DISTINCT elimina linhas que são inteiramente iguais
SELECT DISTINCT CONVERT(CHAR(10),data_inicio,103) AS data_inicio
FROM funcproj
 
--nome_completo e 15% de aumento para Cicrano
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario,
        CAST(salario * 1.15 AS DECIMAL(7,2)) AS pedido_novo_salario
FROM funcionario
WHERE nome = 'Cicrano'
 
--Nome completo e salario de quem ganha mais que 3000
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario
FROM funcionario
WHERE salario > 3000
 
--Nome completo e salario de quem ganha menos que 2000
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario
FROM funcionario
WHERE salario <= 2000
 
--Nome completo e salario de quem ganha entre 2000 e 3000
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario
FROM funcionario
WHERE salario > 2000 AND salario < 3000
 
--BETWEEN
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario
FROM funcionario
WHERE salario BETWEEN 2000 AND 3000
 
--Nome completo e salario de quem ganha menos que 2000 e mais que 3000
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario
FROM funcionario
WHERE salario <= 2000 OR salario >= 3000
 
--NOT BETWEEN
SELECT  id,
        nome+' '+sobrenome AS nome_completo,
        salario
FROM funcionario
WHERE salario NOT BETWEEN 2000 AND 3000

INSERT INTO funcionario VALUES
('Fulano','da Silva Jr.','R. Voluntários da Patria',8150,NULL,'05423110','11','32549874','1990-09-09',1235.00),
('João','dos Santos','R. Anhaia',150,NULL,'03425000','11','45879852','1973-08-19',2352.00),
('Maria','dos Santos','R. Pedro de Toledo',18,NULL,'04426000','11','32568974','1982-05-03',4550.00)

use selects

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


--FUNCOES IMPORTANTES (CHAR E DATAS)
--SUBSTRING & TRIM
--SUBSTRING(CHAR,POSICAOINICIAL,QTDPOSICOES)

select SUBSTRING('Banco de Dados',1, 5) as sub
select SUBSTRING('Banco de Dados',7, 2) as sub
select SUBSTRING('Banco de Dados',10, 5) as sub

select SUBSTRING('Banco de Dados',1,6) as sub
select RTRIM(SUBSTRING('Banco de Dados',1,6)) as sub_rtrim
select SUBSTRING('Banco de Dados',6,4) as sub
select SUBSTRING('Banco de Dados',9,6) as sub


SELECT codigo
        
FROM projeto
WHERE nome = 'Modificação do Módulo de Cadastro'  --PK

select * from funcionario
select * from projeto
select * from funcproj

select nome +' '+sobrenome as nome_completo
from funcionario
 where id in (SELECT  id_funcionario --FK
FROM funcproj
WHERE codigo_projeto in (SELECT codigo
FROM projeto
WHERE nome = 'Modificação do Módulo de Cadastro'))


SELECT DATEDIFF(hour, data_nasc, getdate()) / 8766 as idade,
 nome AS nome
FROM funcionario 


--Nomes completos dos Funcionários que estão no
--projeto Modificação do Módulo de Cadastro