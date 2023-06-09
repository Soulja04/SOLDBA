CREATE DATABASE LearnItFirst
GO
USE LearnItFirst
GO
CREATE USER Marty FOR LOGIN AnotherLogin
GO

CREATE USER Carey FOR LOGIN FinalLogin
WITH DEFAULT_SCHEMA = History
GO
SELECT * FROM sys.database_principals
SELECT * FROM sys.schemas

SELECT SUSER_SNAME() AS CurrentLogin, USER_NAME() AS Username
	, ORIGINAL_LOGIN() AS Original

CREATE SCHEMA History
GO
CREATE TABLE History.Sales (SalesId INT, Amount MONEY)
GO

-- Invalid object name 'Sales'.
EXECUTE AS User='Marty'
SELECT * FROM Sales
REVERT
GO
-- The SELECT permission was denied on the object 'Sales'
EXECUTE AS User='Marty'
SELECT * FROM History.Sales
REVERT
GO
-- No privileges
EXECUTE AS User='Marty'
EXEC sp_table_privileges @table_name='Sales'
REVERT

EXEC sp_table_privileges @table_name='Sales'

-- No permissions
EXECUTE AS User='Marty'
SELECT * FROM sys.fn_my_permissions('History.Sales', 'object')
REVERT

GRANT SELECT ON [History].[Sales] TO [public]
GO

EXECUTE AS User='Marty'
EXEC sp_table_privileges @table_name='Sales'
SELECT * FROM sys.fn_my_permissions('History.Sales', 'object')
REVERT

CREATE TABLE History.Account (AccountId INT, Name NVARCHAR(128))
INSERT History.Account 
VALUES (1, 'Acct1'), (2, 'Acct2'), (3, 'Acct3')
SELECT * FROM History.Account

EXECUTE AS User='Marty'
EXEC sp_table_privileges @table_name='Account'
SELECT * FROM sys.fn_my_permissions('History.Account', 'object')
REVERT

DENY SELECT ON History.Account TO public
GRANT SELECT ON History.Account(Name) TO public

EXECUTE AS User='Marty'
EXEC sp_table_privileges @table_name='Account'
SELECT * FROM sys.fn_my_permissions('History.Account', 'object')
SELECT * FROM History.Account
SELECT Name FROM History.Account
REVERT

-- How to view all possible grantable permissions
SELECT * FROM sys.fn_builtin_permissions('server')
SELECT * FROM sys.fn_builtin_permissions('database')
SELECT * FROM sys.fn_builtin_permissions('schema')
SELECT * FROM sys.fn_builtin_permissions('object')
SELECT * FROM sys.fn_builtin_permissions(DEFAULT)