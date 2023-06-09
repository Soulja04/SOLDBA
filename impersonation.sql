-- View current login:
SELECT SUSER_SNAME() AS MyLogin
	, CASE
		IS_SRVROLEMEMBER('sysadmin', SUSER_SNAME())
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END AS IsSysadmin

-- View all Windows logins:
-- a.k.a. View all SQL Server logins that are mapped
--		to a Windows user account
SELECT *
FROM sys.server_principals
WHERE type=N'U' -- Windows User Accounts
GO

-- Creating a SQL Server login mapped
--	to a Windows user account
CREATE LOGIN [LEARNITFIRST\StandaloneSam] 
FROM WINDOWS 

-- Impersonation is a great security testing tool
SELECT SUSER_SNAME() AS CurrentLogin

-- Switch my "security context" so that I'm logged in 
--	as StandaloneSam
EXECUTE AS LOGIN='LEARNITFIRST\StandaloneSam'
GO
SELECT SUSER_SNAME() AS CurrentLogin
	, ORIGINAL_LOGIN() AS OriginalLogin
GO
-- Fails b/c Sam doesn't have GRANT CREATE DATABASE
CREATE DATABASE StandaloneDb
GO
SELECT * 
FROM sys.server_principals
GO

-- Stop impersonation:
REVERT
GO

SELECT SUSER_SNAME() AS CurrentLogin
	, ORIGINAL_LOGIN() AS OriginalLogin
GO

-- Allows any Windows user that is a member
--	of that group to log into SQL Server
CREATE LOGIN [LEARNITFIRST\Managers] 
FROM WINDOWS 
GO

SELECT p.type, p.type_desc, COUNT(*) AS Entries
FROM sys.server_principals p
GROUP BY p.type, p.type_desc

-- List all Windows groups that have a SQL Server login
SELECT * 
FROM sys.server_principals
WHERE type = N'G'
GO

GRANT CREATE DATABASE TO [LEARNITFIRST\Managers]
GO

-- Fails because you cannot impersonate an entire group!
EXECUTE AS LOGIN = 'LEARNITFIRST\Managers'
GO
SELECT SUSER_SNAME() AS CurrentLogin
	, ORIGINAL_LOGIN() AS OriginalLogin
GO

-- Succeeds because MemberMary is a member of group:
EXECUTE AS LOGIN = 'LEARNITFIRST\MemberMary'
GO
SELECT SUSER_SNAME() AS CurrentLogin
	, ORIGINAL_LOGIN() AS OriginalLogin
GO
CREATE DATABASE MemberMaryDb