/*
	Fatih : 400
	Mehmet : 999,
	Deniz : 385,
	Neslihan : 670,
	G�l�ah : 800,
	Ay�eg�l : 557,
	Mazlum : 1001,
	Ali: 1002,
	Ahmet: 1003
*/
--T-SQL
--SQL : Structure Query Language
--DML : Data Manipulation Language
	--CRUD Operations : CREATE, READ, UPDATE, DELETE
--DDL : Data Definition Language 
--DCL : Data Control Language
--READ

SELECT CAST(4 + 5 * (9 - 2) AS VARCHAR) + ' Ki�i'

SELECT 'Can' AS 'FirstName', 'PERK' AS LastName, 'Kars' AS 'Birth Place'
SELECT 'Deniz' AS 'FirstName', 'ASLAN' AS LastName, 'Ankara' AS 'Birth Place'

SELECT 'Can' AS 'FirstName', 'PERK' AS LastName, 'Kars' AS 'Birth Place'
UNION
SELECT 'Deniz', 'ASLAN','Ankara'

USE Northwind
--SELECT [Alias*.][Kolon ad(lar)�] FROM [TabloAd�] (AS* Alias)
SELECT * FROM Employees--�nerilmez
SELECT e.* FROM Employees AS e --�nerilmez
SELECT FirstName, LastName, City FROM Employees
SELECT FirstName, LastName, City FROM Employees AS e
SELECT e.FirstName, e.LastName, e.City FROM Employees AS e

SELECT FirstName, LastName, City FROM Employees WHERE City = 'London'

SELECT FirstName + ' ' + LastName AS [Full Name], City 
FROM Employees 
WHERE City = 'London'

SELECT FirstName, LastName, City FROM Employees WHERE Country = 'USA'
SELECT FirstName, LastName, City, BirthDate 
FROM Employees
WHERE Country = 'USA' AND BirthDate < '1950-01-01'
--Fiyat� 100 liradan fazla olan �r�nler
SELECT ProductName, UnitPrice 
FROM Products 
WHERE UnitPrice > 100
--Fiyat� 50 ile 100 aras�nda olan �r�nler
SELECT ProductName, UnitPrice FROM Products
--WHERE UnitPrice > 50 AND UnitPrice < 100
WHERE UnitPrice BETWEEN 50 AND 100
--Ya�l�dan Gence personel listesi
SELECT FirstName, LastName, BirthDate FROM Employees
ORDER BY BirthDate ASC
--Gen�ten ya�l�ya personel listesi
SELECT FirstName, LastName, BirthDate FROM Employees
ORDER BY BirthDate DESC
--Ucuzdan pahal�ya �r�n listesi
SELECT ProductName, UnitPrice FROM Products
ORDER BY UnitPrice ASC
--En Ucuz 10 �r�n
--Kritik Stok Seviyesi : 30
SELECT TOP 10 ProductName, UnitPrice, UnitsInStock FROM Products
ORDER BY UnitPrice ASC
--Kampanya yap�labilecek en ucuz 10 �r�n
SELECT TOP 10 ProductName, UnitPrice, UnitsInStock FROM Products
WHERE UnitsInStock >= 30
ORDER BY UnitPrice ASC
--En gen� Amerikal� personel
SELECT TOP 1 FirstName, LastName, BirthDate 
FROM Employees
WHERE Country = 'usa'
ORDER BY BirthDate DESC
--Alfabetik s�raya g�re Almanyal� m��teriler
SELECT CompanyName, ContactName, City, Phone
FROM Customers
WHERE Country = 'Germany'
ORDER BY ContactName
--�lke �nceli�ine g�re m��teri firmalar
SELECT CompanyName, Country FROM Customers
ORDER BY Country, CompanyName 
SELECT ProductName, UnitPrice, UnitsInStock, SupplierID, CategoryID FROM Products

SELECT * FROM Products
SELECT * FROM Suppliers
SELECT * FROM Categories
SELECT * FROM Employees

SELECT * FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID

SELECT p.ProductName, p.UnitPrice, p.UnitsInStock, c.CategoryName, s.CompanyName 
FROM Products AS p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Categories c ON c.CategoryID = p.CategoryID

SELECT p.ProductName, p.UnitPrice, p.UnitsInStock, c.CategoryName, s.CompanyName 
FROM Products AS p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE p.UnitPrice > 50
ORDER BY c.CategoryName
--Tokyo Traders firmas�n�n getirdi�i �r�nler
SELECT p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.CompanyName = 'Tokyo Traders' 
--Beverages (i�ecek) kategorisindeki �r�nler
SELECT p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products p
WHERE p.CategoryID = 1

SELECT p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'

SELECT p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Products p
WHERE CategoryID = (SELECT TOP 1 CategoryID 
					FROM Categories 
					WHERE CategoryName = 'Beverages')

--(Personel) -> Nancy Davolio'nun ald��� sipari�ler
SELECT o.OrderID, o.OrderDate
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.FirstName = 'Nancy' AND e.LastName = 'Davolio'

SELECT o.OrderID, o.OrderDate
FROM Orders o
WHERE o.EmployeeID = (SELECT EmployeeId  
					  FROM Employees
					  WHERE FirstName = 'Nancy' AND LastName = 'Davolio')
USE Northwind
SELECT TOP 5 * FROM Customers
--Londra'daki m��terilerin ald��� �r�nler ve tarihleri
--Can PERK         |  Chai  |  2019-04-28
--Gamze EFEND�O�LU |  Ikura |  2019-04-12
SELECT c.ContactName, p.ProductName, CONVERT (varchar, o.OrderDate, 103) AS OrderDate FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN [Order Details] d ON o.OrderID = d.OrderID
INNER JOIN Products p ON p.ProductID = d.ProductID
WHERE c.City = 'london'
ORDER BY c.ContactName, p.ProductName

--INNER JOIN : Kesin e�lem�me
--LEFT JOIN  : sol tablo kesin gelecek, sa� tablo e�le�enleri getirecek
--RIGHT JOIN : sa� tablo kesin gelecek, sol tablo e�le�enleri getirecek
--CROSS JOIN : komple e�le�me (kartezyen)
--OUTER JOIN*: kullan�ld��� join t�r�ne g�re davran�r

SELECT * FROM Categories WHERE CategoryName = 'Electronics'
SELECT * FROM Products p 
CROSS JOIN Categories c --ON p.CategoryID = c.CategoryID
WHERE p.CategoryID = 9

USE AdventureWorks
SELECT * FROM HumanResources.Employee WHERE BusinessEntityID = 250
SELECT * FROM Person.Person WHERE BusinessEntityID = 250
SELECT * FROM Person.EmailAddress WHERE BusinessEntityID = 250

SELECT e.LoginID, h.StartDate, d.Name, d.GroupName 
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory h ON e.BusinessEntityID = h.BusinessEntityID
INNER JOIN HumanResources.Department d ON d.DepartmentID = h.DepartmentID
WHERE e.BusinessEntityID = 250;

--�r�n Kategorileri
SELECT c.Name CategoryName,  p.Name AS ProductName FROM Production.Product p
INNER JOIN Production.ProductSubcategory s ON s.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Production.ProductCategory c ON s.ProductCategoryID = c.ProductCategoryID
WHERE c.Name = 'Bikes'
ORDER BY CategoryName, ProductName
--Ada g�re �r�n arama
SELECT * FROM Production.Product 
WHERE Name LIKE '% red %'
--Hangi �r�n hangi depoda ka� tane var
SELECT p.Name [Product Name], l.Name AS [Store Name], i.Quantity
FROM Production.ProductInventory i
INNER JOIN Production.Location l ON i.LocationID = l.LocationID
INNER JOIN Production.Product p ON p.ProductID = i.ProductID
ORDER BY p.Name, i.Quantity DESC

--Hangi �r�nden ka� tane var
--AGGREGATE FUNCTION
SELECT p.Name [Product Name], SUM(i.Quantity) AS Summary
FROM Production.ProductInventory i
INNER JOIN Production.Location l ON i.LocationID = l.LocationID
INNER JOIN Production.Product p ON p.ProductID = i.ProductID
GROUP BY p.Name --haftaya bakaca��z
ORDER BY p.Name

--Hangi depoda ka� �r�n var
SELECT l.Name, SUM(i.Quantity) AS Summary
FROM Production.ProductInventory i
INNER JOIN Production.Location l ON i.LocationID = l.LocationID
INNER JOIN Production.Product p ON p.ProductID = i.ProductID
GROUP BY l.Name
ORDER BY l.Name
USE Northwind
--1997 Haziran ay�nda yap�lm�� sat��lar
SELECT * FROM Orders
WHERE OrderDate >= '1997-06-01' AND OrderDate < '1997-07-01'
ORDER BY OrderDate

SELECT * FROM Orders
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 6 --AND DAY(OrderDate) = 4

USE AdventureWorks
--WITH TIES : Son ilgili de�er ile ayn� de�ere sahip olup, s�ralamaya top keyword'� 
--sebebi ile giremeyen kay�tlar� g�rmek i�in kullan�l�r
SELECT TOP 3 WITH TIES 
	p.FirstName + ' ' + p.LastName AS Employee, 
	CONVERT(VARCHAR, e.BirthDate, 103) AS BirthDate, 
	d.Name AS DepartmentName, 
	h.StartDate
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory h ON e.BusinessEntityID = h.BusinessEntityID
INNER JOIN HumanResources.Department d ON d.DepartmentID = h.DepartmentID
ORDER BY BirthDate ASC
SET STATISTICS IO OFF --ON
SET STATISTICS TIME OFF --ON
--Sat�n Alma Ajans� (Purchasing Agent) olan ki�ilerin ileti�im numaralar�
SELECT p.FirstName, p.LastName, h.PhoneNumber, e.EmailAddress 
FROM Person.Person p
INNER JOIN Person.PersonPhone h ON p.BusinessEntityID = h.BusinessEntityID
INNER JOIN Person.BusinessEntityContact b ON b.PersonID = p.BusinessEntityID
INNER JOIN Person.ContactType c ON c.ContactTypeID = b.ContactTypeID
INNER JOIN Person.EmailAddress e ON e.BusinessEntityID = p.BusinessEntityID
WHERE c.Name = 'Purchasing Agent'

SELECT p.FirstName, p.LastName, h.PhoneNumber, e.EmailAddress 
FROM Person.Person p
INNER JOIN Person.PersonPhone h ON p.BusinessEntityID = h.BusinessEntityID
INNER JOIN Person.BusinessEntityContact b ON b.PersonID = p.BusinessEntityID
INNER JOIN Person.EmailAddress e ON e.BusinessEntityID = p.BusinessEntityID
WHERE b.ContactTypeID = (SELECT TOP 1 ContactTypeId FROM Person.ContactType WHERE Name = 'Purchasing Agent')
--AGGREGATE FUNCTION
USE Northwind
SELECT COUNT(0) FROM Employees
SELECT COUNT(0) FROM Products
SELECT COUNT(*) AS [Count of Orders] FROM Orders
--Her bir kategoriden ka� �r�n var
SELECT c.CategoryName, COUNT(0) AS [Count] FROM Products p
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY [Count] DESC

SELECT TOP 1 
	FirstName, LastName, BirthDate, GETDATE() AS Now, YEAR(GETDATE()) - YEAR(BirthDate) AS Diff 
FROM Employees

SELECT TOP 1 
	FirstName, LastName, YEAR(GETDATE()) - YEAR(BirthDate) AS Diff --DATEDIFF ile deneyin. Bkz: 298 (Ctrl + G)
FROM Employees

SELECT CONVERT(varchar, CAST(123456 AS Money), 1) AS test

SELECT SUM(YEAR(GETDATE()) - YEAR(BirthDate)) AS Summary FROM Employees
SELECT SUM(YEAR(GETDATE()) - YEAR(BirthDate)) / COUNT(0) AS Summary FROM Employees
SELECT AVG(YEAR(GETDATE()) - YEAR(BirthDate)) AS Summary FROM Employees
--1998 y�l�nda ne kadarl�k sat�� cirosu al�nm��
SELECT SUM(od.UnitPrice * od.Quantity) AS Total
FROM [Order Details] od
INNER JOIN Orders o ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1998
--1998 y�l�nda hangi m��teri ne kadarl�k sipari� vermi�
SELECT c.CompanyName, SUM(d.Quantity * d.UnitPrice) AS Summary 
FROM [Order Details] d
INNER JOIN Orders o ON o.OrderID = d.OrderID
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1998
GROUP BY c.CompanyName
ORDER BY Summary DESC
--1998 y�l�nda hangi personel ne kadarl�k sat�� yapm��
SELECT e.FirstName, e.LastName, SUM(d.Quantity * d.UnitPrice) AS Summary FROM Employees e
INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] d ON d.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1998
GROUP BY e.FirstName, e.LastName
ORDER BY Summary DESC
--Margaret	Peacock, Eastern Connection'dan ald��� sipari�ler ve sipari� ba��na toplam �cret
SELECT o.OrderDate, SUM(d.UnitPrice * d.Quantity) AS Summary FROM Orders o
INNER JOIN [Order Details] d ON o.OrderID = d.OrderID
WHERE o.CustomerID = (SELECT TOP 1 CustomerID FROM Customers 
					  WHERE CompanyName = 'Eastern Connection') AND
	  o.EmployeeID = (SELECT TOP 1 EmployeeID FROM Employees 
				      WHERE FirstName = 'Margaret' AND LastName = 'Peacock')
GROUP BY o.OrderDate
-- sekiz ay �nceki ve daha �ncesinde al�nm�� sipari�ler
SELECT * FROM Orders WHERE OrderDate < DATEADD(month,-8,GETDATE()) 
-- tarih fark�
SELECT DATEDIFF(YEAR, '1988-02-08', GETDATE())

--AdventureWorks;
--'Road-450 Red, 44' isimli bisiklet hangi depoda ka� tane var ve ka� liral�k �r�n var listeleyin
USE AdventureWorks
SELECT l.Name, i.Quantity AS [Count], SUM(p.ListPrice * i.Quantity) AS Total 
FROM Production.ProductInventory i
INNER JOIN Production.Product p ON i.ProductID = p.ProductID
INNER JOIN Production.Location l ON l.LocationID = i.LocationID
WHERE p.Name = 'Road-450 Red, 44'
GROUP BY l.Name, i.Quantity

USE Northwind
SELECT ProductName, UnitPrice, UnitsInStock 
FROM Products
WHERE CategoryID IN (1,4,8)
--WHERE CategoryID = 1 OR CategoryID = 4 OR CategoryID = 8

SELECT ProductName, UnitPrice, UnitsInStock, CategoryID 
FROM Products
WHERE CategoryID IN (SELECT CategoryID FROM Categories 
				     WHERE CategoryName IN ('Dairy Products', 'Beverages', 'Seafood'))
ORDER BY ProductName

SELECT * FROM Categories
--Hem Nancy hem de Robert'�n 1996 aral�k ay�nda ald�klar� sipari�ler
SELECT * FROM Orders 
WHERE YEAR(OrderDate) = 1996 AND MONTH(OrderDate) = 12 AND
	  EmployeeID IN (SELECT EmployeeID FROM Employees 
					 WHERE FirstName IN ('nancy', 'robert'))
--Hem Nancy hem de Robert'�n 1996 aral�k ay�nda elde ettikleri gelir
SELECT e.FirstName, e.LastName, SUM(d.Quantity * d.UnitPrice) AS Summary 
FROM [Order Details] d
LEFT JOIN Orders o ON o.OrderID = d.OrderID
LEFT JOIN Employees e ON e.EmployeeID = o.EmployeeID
WHERE YEAR(OrderDate) = 1996 AND MONTH(OrderDate) = 12 AND 
	  e.FirstName IN ('nancy', 'Robert')
GROUP BY e.FirstName, e.LastName
UNION
SELECT 'Robert', 'King', 0
--MIN - MAX

SELECT MAX(UnitPrice) FROM Products
SELECT MIN(UnitPrice) FROM Products
--En pahal� �r�n
SELECT ProductName, MAX(UnitPrice) FROM Products
GROUP BY ProductName -- MAX ve MIN group by ile mant�kl� sonu�lar veremiyor

SELECT * FROM Products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products)
--En ucuz �r�n
SELECT * FROM Products WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM Products)

SELECT * FROM Products WHERE ProductID = 1078

SELECT p.ProductID, s.CompanyName, c.CategoryName, p.ProductName
FROM Products p
LEFT JOIN Suppliers s ON s.SupplierID = p.SupplierID
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
--id si verilen �r�n�n sadece sa�lay�c� firma ad�n�, firmas� yoksa kategori
--ad�n�, kategorisi yoksa �r�n�n ad�n� getiriniz

--COALESCE parametrik de�erleri i�inde getirilen kolon de�eri NULL olmayana kadar bir sonraki 
--parametreye ge�er. 
SELECT COALESCE(s.CompanyName, c.CategoryName, p.ProductName, 'De�er Yok') AS Result
FROM Products p
LEFT JOIN Suppliers s ON s.SupplierID = p.SupplierID
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE p.ProductID = 1078

--Sa�lay�c�s� olmayan �r�nler
SELECT * FROM Products WHERE SupplierID IS NULL
--Sa�lay�c�s� olan �r�nler
SELECT * FROM Products WHERE SupplierID IS NOT NULL
--Kategorisi olmayan �r�nler
SELECT * FROM Products WHERE CategoryID IS NULL
--Kategorisi olan �r�nler
SELECT * FROM Products WHERE CategoryID IS NOT NULL
SELECT * FROM Products WHERE CategoryID IS NULL AND SupplierID IS NULL

USE AdventureWorks
SELECT p.FirstName, 
	   p.LastName, 
	   CASE e.MaritalStatus WHEN 'M' THEN 'Evli'
						    WHEN 'S' THEN 'Bek�r'
							ELSE 'Belirsiz'
	   END AS MaritalStatus,
	    e.Gender 
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
--Northwind'de �r�nleri listelerken kategorisi ve/veya sa�lay�c�s� olmayan �r�nler i�in
--TANIMSIZ ��kt�s� al�ns�n
USE Northwind
SELECT p.ProductName, 
	   CASE WHEN c.CategoryName IS NULL THEN 'TANIMSIZ'
		    ELSE c.CategoryName END AS Category,
	   CASE WHEN s.CompanyName IS NULL THEN 'TANIMSIZ'
		    ELSE s.CompanyName END AS Company
FROM Products p
LEFT JOIN Suppliers s ON s.SupplierID = p.SupplierID
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID

--Sayfalama
DECLARE @pageNumber INT
DECLARE @start INT
DECLARE @pageSize INT
SET @pageNumber = 1
SET @pageSize = 10
SET @start = (@pageNumber - 1) * @pageSize
SELECT * FROM Products
ORDER BY ProductId
OFFSET @start ROWS FETCH NEXT @pageSize ROWS ONLY
--AdventureWorks i�in
USE AdventureWorks
--2011 Haziran ay�nda sat�lan �r�nleri, toplam elde edilen gelir 
--ile beraber 15'erli sayfalar halinde getiriniz
SELECT p.Name AS ProductName, SUM(d.LineTotal) AS TotalIncome  --CONVERT(VARCHAR, CAST(SUM(LineTotal) AS MONEY), 1) AS TotalIncome 
FROM Sales.SalesOrderDetail d
INNER JOIN Production.Product p ON p.ProductID = d.ProductID
WHERE d.SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderHeader
						 WHERE YEAR(OrderDate) = 2011 AND MONTH(OrderDate) = 6)
GROUP BY p.Name
ORDER BY TotalIncome DESC
OFFSET 0 ROWS FETCH NEXT 15 ROWS ONLY -- OFFSET 15'erli artmal�
--5 May�s 2013 tarihinde yap�lan sat��lar�n dolar cinsinden toplam de�erleri
--ile beraber m��teri bilgileri ve sat��� yapan personel bilgileri ile ekrana yazd�r�n�z 

--5 May�s 2013 tarihinde yap�lan sat��larda �r�nlerde yap�lan toplam indirimleri �r�n baz�nda listeleyiniz