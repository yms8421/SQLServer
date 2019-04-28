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