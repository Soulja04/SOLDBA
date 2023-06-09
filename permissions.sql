


/*
SQL Server offers three pretty simple commands to give and remove access, these commands are:

GRANT - gives a user permission to perform certain tasks on database objects 
DENY - denies any access to a user to perform certain tasks on database objects 
REVOKE - removes a grant or deny permission from a user on certain database objects
Here are some examples of these commands.

Allow users Joe and Mary to SELECT, INSERT and UPDATE data in table Customers */

              GRANT INSERT, UPDATE, SELECT ON Customers TO Joe, Mary

Revoke UPDATE access to table Customers for user Joe

              REVOKE UPDATE ON Customers to Joe

DENY DELETE access to table Customers for user Joe and Mary

              DENY DELETE ON Customers to Joe, Mary

As you can see from the above examples it is pretty easy to grant, deny and revoke access. In addition to grant SELECT, INSERT, DELETE and UPDATE rights you can also grant EXECUTE rights to run a stored procedure as follows:

              GRANT EXEC ON uspInsertCustomers TO Joe

To determine what rights have been granted in a database use the sp_helprotect stored procedure.

              GRANT CREATE TABLE TO Joe


			  --Syntax: SELECT * FROM sys.fn_my_permissions(securable, 'class')
-- SELECT * FROM sys.fn_my_permissions(null, null) -- returns all perms
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')

-- View other logins:
SELECT * FROM sys.server_principals
WHERE type = 'S'

EXECUTE AS LOGIN = 'MyNewLogin'
GO
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')

-- Fails!
CREATE DATABASE MyDb
GO
REVERT
SELECT SUSER_SNAME() AS CurrentLogin, ORIGINAL_LOGIN() AS Original

SELECT * FROM sys.fn_my_permissions(null, 'SERVER')

GRANT CREATE ANY DATABASE TO MyNewLogin
GO

EXECUTE AS LOGIN = 'MyNewLogin'
GO
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')

CREATE DATABASE MyDb
GO
REVERT


SELECT SUSER_SNAME() AS CurrentLogin, ORIGINAL_LOGIN() AS Original


EXECUTE AS LOGIN = 'MyNewLogin'
GO
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')

SELECT * FROM sys.databases

USE LogFiller
REVERT

-- DBAs assign perms on securables to principals
DENY VIEW ANY DATABASE TO MyNewLogin

EXECUTE AS LOGIN = 'MyNewLogin'
GO
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')

-- Lists any dbs that have a guest user, or that login owns
SELECT * FROM sys.databases
REVERT

REVOKE VIEW ANY DATABASE TO MyNewLogin
GO
REVERT

ALTER SERVER ROLE [sysadmin] 
ADD MEMBER [MyNewLogin]
GO
EXECUTE AS LOGIN = 'MyNewLogin'
SHUTDOWN
GO

SELECT SUSER_SNAME() AS CurrentLogin, ORIGINAL_LOGIN() AS Original

ALTER SERVER ROLE [sysadmin] 
DROP MEMBER [MyNewLogin]
GO

EXECUTE AS LOGIN = 'MyNewLogin'
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')
SHUTDOWN
REVERT
GO
GRANT CONTROL SERVER TO MyNewLogin
GO
EXECUTE AS LOGIN = 'MyNewLogin'
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')
SHUTDOWN
REVERT
GO
DENY SHUTDOWN TO MyNewLogin
GO
EXECUTE AS LOGIN = 'MyNewLogin'
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')
SHUTDOWN
REVERT

REVOKE SHUTDOWN TO MyNewLogin
REVOKE CONTROL SERVER TO MyNewLogin

GO
CREATE SERVER ROLE [JuniorDBAs]
GO
ALTER SERVER ROLE [JuniorDBAs] ADD MEMBER [MyNewLogin]
GO
DENY SHUTDOWN TO [JuniorDBAs]
GRANT CONTROL SERVER TO JuniorDBAs
GO

EXECUTE AS LOGIN = 'MyNewLogin'
SELECT * FROM sys.fn_my_permissions(null, 'SERVER')
SHUTDOWN
REVERT




