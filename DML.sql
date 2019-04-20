--T-SQL
--SQL : Structure Query Language
--DML : Data Manipulation Language
	--CRUD Operations : CREATE, READ, UPDATE, DELETE

--READ

SELECT CAST(4 + 5 * (9 - 2) AS VARCHAR) + ' Kiþi'

SELECT 'Can' AS 'FirstName', 'PERK' AS LastName, 'Kars' AS 'Birth Place'
SELECT 'Deniz' AS 'FirstName', 'ASLAN' AS LastName, 'Ankara' AS 'Birth Place'

SELECT 'Can' AS 'FirstName', 'PERK' AS LastName, 'Kars' AS 'Birth Place'
UNION
SELECT 'Deniz', 'ASLAN','Ankara'

USE Northwind
SELECT * FROM Employees