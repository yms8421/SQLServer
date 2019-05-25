--DDL : Data Definition language
	--C(R)UD : CREATE (READ) UPDATE DELETE
	--CUD:DDL => CREATE, (SELECT), ALTER, DROP 

CREATE DATABASE CanBookShelve
DROP DATABASE CanBookShelve
GO

CREATE DATABASE CanBookShelve
ON
( NAME = CanBookShelve_data,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CanBookShelve.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5
)
LOG ON
( NAME = CanBookShelve_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Log\CanBookShelve.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB
)
COLLATE Turkish_CI_AI;
GO
USE CanBookShelve

CREATE TABLE Countries
(
	--Kolon adý, türü, [CONSTRAINT'ler]
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(30) NOT NULL
)
GO
INSERT INTO dbo.Countries(Name) VALUES ('Türkiye')--, ('Almanya'), ('Rusya')
INSERT INTO dbo.Countries(Name) VALUES ('Almanya')
INSERT INTO dbo.Countries(Name) VALUES ('Rusya')
INSERT INTO dbo.Countries(Name) VALUES ('Japonya')
INSERT INTO dbo.Countries(Name) VALUES ('A.B.D')
INSERT INTO dbo.Countries(Name) VALUES ('Ýngiltere')
GO

CREATE TABLE Authors
(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	CountryId INT NULL,
	--CONSTRAINT [name] [CONSTRAINT Name] [Kolon] (? REFERENCES [Tablo]([Kolon]) ?)
	CONSTRAINT FK_Authors_Countries FOREIGN KEY (CountryId) REFERENCES dbo.Countries(Id)
)
--DROP TABLE dbo.Authors

INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Ömer','Seyfettin', 1)
INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Joanne Kathleen','Rowling', 7)
INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Mihayl Fyodor','Dostoyevski', 3)
INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Mehmet Akif','Ersoy', 1)
--INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
--VALUES('Mehmet Akif Çok Uzun Bir Ýsim','Ersoy', 1)

SELECT * FROM dbo.Authors a
INNER JOIN dbo.Countries c ON c.Id = a.CountryId

CREATE TABLE Books
(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Title VARCHAR(50) NOT NULL,
	AuthorId INT NULL,
)
INSERT INTO dbo.Books(Title,AuthorId)
VALUES ('Pembe Ýncili Kaftan', 2),
	   ('Suç ve Ceza', 4),
	   ('Harry Potter Sýrlar Odasý', NULL)

INSERT INTO dbo.Books(Title,AuthorId)
VALUES ('Baþýný Vermeyen Þehit', 2)

SELECT * FROM dbo.Books

GO
--Kolon ekle
ALTER TABLE Books
ADD Price MONEY NULL

--Kolon bilgisini güncelle
ALTER TABLE dbo.Books
ALTER COLUMN Price MONEY NOT NULL
GO
--Kolon sil
ALTER TABLE dbo.Books
DROP COLUMN Price

ALTER TABLE Books
ADD Price MONEY NOT NULL DEFAULT(0)

ALTER TABLE Books
ADD CreatedDate DATETIME NOT NULL DEFAULT(GETDATE())

ALTER TABLE Books
ADD IsActive BIT NOT NULL DEFAULT(1)
GO
UPDATE dbo.Books SET Price = 5 WHERE Id = 1


ALTER TABLE dbo.Books
ADD CONSTRAINT FK_Book_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(Id)

/*ÖDEV : Ödünç mekanizmasýný tablo seviyesinde tasarlayýnýz
		 Örnek olarak daha önce kaydedilmiþ kiþilerin mevcut bulunan bir kitabý 
		 ödünç almasý ve ne zaman geri getireceði ve getirip getirmediði durumunu
		 baþka bir tabloda ayarlayýnýz
		*/
GO
CREATE SCHEMA Sales --> Security altýndan kontrol et
GO
USE Northwind
--View: Sanal Tablo
GO
CREATE VIEW vPhoneBook AS
(
	SELECT FirstName + ' ' + LastName AS FullName, HomePhone, 'Employee' AS Type 
	FROM dbo.Employees WHERE HomePhone IS NOT NULL
	UNION
	SELECT ContactName, Phone, 'Customer' 
	FROM dbo.Customers
	
);
GO
ALTER VIEW vPhoneBook AS
(
	SELECT UPPER(FirstName + ' ' + LastName) AS FullName, HomePhone, 'E' AS PersonType 
	FROM dbo.Employees WHERE HomePhone IS NOT NULL
	UNION
	SELECT UPPER(ContactName), Phone, 'C' 
	FROM dbo.Customers
	UNION
	SELECT UPPER(ContactName), Phone, 'S' FROM dbo.Suppliers
);
GO
SELECT * FROM vPhoneBook
DROP VIEW dbo.vPhoneBook
GO
ALTER VIEW vBeverages WITH SCHEMABINDING
AS 
(
	SELECT Productname, UnitPrice, UnitsInStock,CategoryID
	FROM dbo.Products 
	WHERE CategoryID = 1
) 
GO
SELECT * FROM dbo.vBeverages; 
--ÖDEV
--WITH ENCRYPTION (2 kullanýcý)
INSERT INTO dbo.vBeverages(ProductName,UnitPrice,UnitsInStock,CategoryID)
VALUES('Ramazan Þerbeti', 1, 1000, 1)

ALTER TABLE dbo.Products
DROP COLUMN CategoryID
GO
--FUNCTION, STORED PROCEDURE, TRIGGER, TRANSACTION, AGENT

--FUNCTIONS
CREATE FUNCTION Multiply
(
	@value1 DECIMAL,
	@value2 DECIMAL
)
RETURNS DECIMAL
AS
BEGIN
	RETURN @value1 * @value2
END
--decimal Multiply(decimal value1, decimal value2)
--{
--		return value1 * value2;
--}
SELECT TOP 5 ProductName, dbo.Multiply(UnitPrice, UnitsInStock) AS Summary 
FROM dbo.Products
GO
ALTER FUNCTION Multiply
(
	@value1 DECIMAL,
	@value2 DECIMAL
)
RETURNS DECIMAL
AS
BEGIN
	DECLARE @result DECIMAL
	SET @result = @value1 * @value2
	IF @result = 0
	BEGIN
		RETURN NULL
	END
	RETURN @result
END

SELECT FLOOR(RAND() * 100)
SELECT 1 * NULL

SELECT TOP 5 ProductName, dbo.Multiply(UnitPrice, UnitsInStock) AS Summary 
FROM dbo.Products
--Ödev: kendisine verilen deðeri Örnek ('1,2,3,6') Tablo olarak dönen fonskiyon
GO

CREATE FUNCTION StringToRow
(
	@param VARCHAR(100)
)
RETURNS TABLE 
AS RETURN SELECT ProductID FROM dbo.Products
GO
DROP FUNCTION StringToRow
GO
ALTER FUNCTION dbo.StringToRow
(
	@param VARCHAR(100)
)
RETURNS @numbers TABLE 
(
	Id INT NOT NULL
)
AS BEGIN
	INSERT INTO @numbers
	SELECT CONVERT(INT, TRIM(value)) FROM STRING_SPLIT('1,2,3, 5 ,6,12', ',')
	RETURN;
END

--SELECT * FROM dbo.StringToRow('1,2,3,5,6,12')
--SELECT CONVERT(INT, TRIM(value)) FROM STRING_SPLIT('1,2,3, 5 ,6,12', ',')

SELECT * FROM dbo.StringToRow('1,2,3, 5 ,6,12')
SELECT * FROM dbo.Products WHERE ProductID IN 
	(SELECT * FROM dbo.StringToRow('1,2,3, 5 ,6,12'))

GO
--STORED PROCEDURES
CREATE PROCEDURE spDefineEmployee
(
	@firstName VARCHAR(20),
	@lastName VARCHAR(20),
	@birthDate DATETIME,
	@phone VARCHAR(18)
)
AS BEGIN
	INSERT INTO Employees (FirstName,LastName,BirthDate, HomePhone, City, Country ,HireDate)
	VALUES (@firstName, @lastName, @birthDate, @phone, 'Ankara', 'Turkey', GETDATE())

	SELECT * FROM dbo.Employees WHERE EmployeeID = @@IDENTITY
	--SELECT SYSTEM_USER
END

GO
EXEC dbo.spDefineEmployee @firstName = 'Özgür', @lastName = 'Kýlýnçlar', @birthDate = '1994-05-02', @phone = '543 2220910'                         -- varchar(18)

CREATE TABLE AllPeople
(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	City VARCHAR(20) NOT NULL,
	BirthDate DATETIME,
	Salary MONEY
)
GO 
SELECT * FROM dbo.AllPeople

DROP TABLE dbo.AllPeople
GO
ALTER PROCEDURE createDummyPeople
(
	@count INT
)
AS BEGIN
	DECLARE @index INT
	SET @index = 1
	WHILE @index < @count
	BEGIN
		INSERT INTO dbo.AllPeople
		(
		    FirstName,
		    LastName,
			BirthDate,
		    City,
		    Salary
		)
		
		VALUES 
		(
			'Can' + CAST(@index AS VARCHAR(20)), 
			'Perk' + CAST(@index AS VARCHAR(20)), 
			DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0), 
			'Ankara', 
			ROUND(RAND() * 10000, 2) 
		)
		SET @index = @index + 1
		IF @index % 10000 = 0
		BEGIN
			PRINT @index
		END
	END
END

EXEC dbo.createDummyPeople @count = 1000000

SELECT DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0)
SELECT CHECKSUM(NEWID()) % 65530
SELECT ROUND(RAND() * 10000, 2) 

--TRANSACTION
SELECT * FROM dbo.Categories
SELECT * FROM dbo.Categories WITH (NOLOCK)
SELECT * FROM dbo.Categories WHERE CategoryID <> 1
BEGIN TRAN
UPDATE dbo.Categories SET CategoryName = 'Beverages' WHERE CategoryID = 1
COMMIT TRAN
ROLLBACK TRAN

DECLARE @Table TABLE(
        SPID INT,
        Status VARCHAR(MAX),
        LOGIN VARCHAR(MAX),
        HostName VARCHAR(MAX),
        BlkBy VARCHAR(MAX),
        DBName VARCHAR(MAX),
        Command VARCHAR(MAX),
        CPUTime INT,
        DiskIO INT,
        LastBatch VARCHAR(MAX),
        ProgramName VARCHAR(MAX),
        SPID_1 INT,
        REQUESTID INT
)

INSERT INTO @Table EXEC sp_who2

SELECT  *
FROM    @Table
WHERE DBName = 'Northwind'

KILL 55

SELECT * FROM sys.sysprocesses WHERE open_tran = 1

KILL 60

--TRIGGER, AGENT, Common Table Expression