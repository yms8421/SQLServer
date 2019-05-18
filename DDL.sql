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
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(30) NOT NULL
)
GO
INSERT INTO dbo.Countries(Name) VALUES ('T�rkiye')--, ('Almanya'), ('Rusya')
INSERT INTO dbo.Countries(Name) VALUES ('Almanya')
INSERT INTO dbo.Countries(Name) VALUES ('Rusya')
INSERT INTO dbo.Countries(Name) VALUES ('Japonya')
INSERT INTO dbo.Countries(Name) VALUES ('A.B.D')
INSERT INTO dbo.Countries(Name) VALUES ('�ngiltere')
GO

CREATE TABLE Authors
(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	CountryId INT NULL,

	CONSTRAINT FK_Authors_Countries FOREIGN KEY (CountryId) REFERENCES dbo.Countries(Id)
)
--DROP TABLE dbo.Authors

INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('�mer','Seyfettin', 1)
INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Joanne Kathleen','Rowling', 7)
INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Mihayl Fyodor','Dostoyevski', 3)
INSERT INTO dbo.Authors(FirstName, LastName, CountryId)
VALUES('Mehmet Akif','Ersoy', 1)

SELECT * FROM dbo.Authors a
INNER JOIN dbo.Countries c ON c.Id = a.CountryId

CREATE TABLE Books
(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Title VARCHAR(50) NOT NULL,
	AuthorId INT NULL,
)
INSERT INTO dbo.Books(Title,AuthorId)
VALUES ('Pembe �ncili Kaftan', 2),
	   ('Su� ve Ceza', 4),
	   ('Harry Potter S�rlar Odas�', NULL)

SELECT * FROM dbo.Books

GO
--Kolon ekle
ALTER TABLE Books
ADD Price MONEY NULL

--Kolon bilgisini g�ncelle0
ALTER TABLE dbo.Books
ALTER COLUMN Price MONEY NOT NULL
GO
--Kolon sil
ALTER TABLE dbo.Books
DROP COLUMN Price

ALTER TABLE Books
ADD Price MONEY NOT NULL DEFAULT(0)

GO
UPDATE dbo.Books SET Price = 5 WHERE Id = 1


ALTER TABLE dbo.Books
ADD CONSTRAINT FK_Book_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(Id)

/*�DEV : �d�n� mekanizmas�n� tablo seviyesinde tasarlay�n�z
		 �rnek olarak daha �nce kaydedilmi� ki�ilerin mevcut bulunan bir kitab� 
		 �d�n� almas� ve ne zaman geri getirece�i ve getirip getirmedi�i durumunu
		 ba�ka bir tabloda ayarlay�n�z
		*/
GO
CREATE SCHEMA Sales --> Security alt�ndan kontrol et
GO
USE Northwind
--View: Sanal Tablo
GO
CREATE VIEW vPhoneBook AS
(
	SELECT FirstName + ' ' + LastName AS FullName, HomePhone, 'Employee' AS Type 
	FROM dbo.Employees
	UNION
	SELECT ContactName, Phone, 'Customer' 
	FROM dbo.Customers
);
GO
ALTER VIEW vPhoneBook AS
(
	SELECT UPPER(FirstName + ' ' + LastName) AS FullName, HomePhone, 'E' AS PersonType 
	FROM dbo.Employees
	UNION
	SELECT UPPER(ContactName), Phone, 'C' 
	FROM dbo.Customers
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
--�DEV
--WITH ENCRYPTION (2 kullan�c�)
INSERT INTO dbo.vBeverages(ProductName,UnitPrice,UnitsInStock,CategoryID)
VALUES('Ramazan �erbeti', 1, 1000, 1)

ALTER TABLE dbo.Products
DROP COLUMN CategoryID

--FUNCTION, STORED PROCEDURE, TRIGGER, TRANSACTION, AGENT