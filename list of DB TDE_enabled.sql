SELECT *
FROM sys.databases

-- DBAs need to have scripts that show them a list of databases
--	that meet certain criteria

-- Lists all databases that have TDE enabled:
SELECT *
FROM sys.databases d
WHERE d.is_encrypted = 1

SELECT * 
FROM sys.databases d
WHERE d.name = N'LearnItFirst2';

SELECT 
	is_read_only
	, is_auto_shrink_on
	, collation_name
FROM sys.databases d
WHERE d.name = N'LearnItFirst2';

SELECT 
	CASE is_read_only
		WHEN 0 THEN 'Off'
		ELSE 'On'
	END AS is_read_only
	, CASE is_auto_shrink_on
		WHEN 0 THEN 'Off'
		ELSE 'On'
	END AS is_auto_shrink_on
	, collation_name
FROM sys.databases d
WHERE d.name = N'LearnItFirst2';

SELECT d.name
	, CASE is_read_only
		WHEN 0 THEN 'Off'
		ELSE 'On'
	END AS is_read_only
	, CASE is_auto_shrink_on
		WHEN 0 THEN 'Off'
		ELSE 'On'
	END AS is_auto_shrink_on
	, collation_name
FROM sys.databases d
ORDER BY d.name

-- Set the database engine's behavior to be SQL Server 2005:
ALTER DATABASE [LearnItFirst2] 
SET COMPATIBILITY_LEVEL = 90
GO

-- Set the database engine's behavior to be SQL Server 2008:
ALTER DATABASE [LearnItFirst2] 
SET COMPATIBILITY_LEVEL = 100
GO

-- Set the database engine's behavior to be SQL Server 2012:
ALTER DATABASE [LearnItFirst2] 
SET COMPATIBILITY_LEVEL = 110
GO

SELECT d.compatibility_level
FROM sys.databases d
WHERE d.name = N'LearnItFirst2';

-- Old school: assign a password to a backup file!
BACKUP DATABASE LearnItFirst2 TO DISK ='c:\sfgsjgfh'
WITH PASSWORD='Q)@#*$&KJGG'
