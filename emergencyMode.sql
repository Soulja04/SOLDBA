CREATE DATABASE SplitLog 
ON PRIMARY
(Name = 'SplitLogData', Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SplitLogData.mdf'
	, Size = 30MB, MAXSIZE=100MB, FILEGROWTH=0)
LOG ON (
	Name = 'SplitLogLog'
	, FileName = 'F:\SQL Server Data Files\SplitLogLog.ldf'
	, Size = 1MB
	, Maxsize = 15MB
	, Filegrowth = 10%
)
GO
ALTER DATABASE SplitLog SET RECOVERY FULL
GO
BACKUP DATABASE SplitLog TO DISK = 'SplitLog.bak'
GO
USE SplitLog
GO
CREATE TABLE LargeTable (ColA CHAR(8000))
GO
SET NOCOUNT ON 
GO
INSERT LargeTable VALUES ('Hey')
GO 100
GO

BACKUP LOG SplitLog TO DISK = 'SplitLog.bak'
GO
BEGIN TRAN 
	INSERT LargeTable VALUES ('Next to last row')
COMMIT TRAN

BEGIN TRAN
	INSERT LargeTable VALUES ('Last row')
	
SELECT COUNT(*) FROM SplitLog.dbo.LargeTable

-- Shut down, delete log file, resume service
USE SplitLog

SELECT DATABASEPROPERTYEX('SplitLog', 'Status')

-- Fails:
BACKUP LOG SplitLog
TO DISK = 'SplitLogLastBackup.bak'
WITH NO_TRUNCATE

-- Fails
BACKUP DATABASE SplitLog
TO DISK = 'SplitLogLastBackup.bak'
WITH COPY_ONLY

-- Fails
BACKUP DATABASE SplitLog
TO DISK = 'SplitLogLastBackup.bak'
WITH CONTINUE_AFTER_ERROR

SELECT DATABASEPROPERTYEX('SplitLog', 'UserAccess')

-- Fails:
ALTER DATABASE SplitLog SET ONLINE

-- We can set the database in "Emergency mode"
-- Four steps to using emergency mode
--		Step 1: Set emergency
--		Step 2: Set database in single user
--		Step 3: DBCC
--		Step 4: Set database in multi user

--		Step 1: Set emergency
ALTER DATABASE SplitLog SET EMERGENCY

SELECT DATABASEPROPERTYEX('SplitLog', 'UserAccess') AS UserAccess
	, DATABASEPROPERTYEX('SplitLog', 'Status') AS Status
	
SELECT COUNT(*) FROM SplitLog.dbo.LargeTable

--		Step 2: Set database in single user
ALTER DATABASE SplitLog SET SINGLE_USER

--		Step 3: DBCC
DBCC CHECKDB('SplitLog', REPAIR_ALLOW_DATA_LOSS)

SELECT DATABASEPROPERTYEX('SplitLog', 'UserAccess') AS UserAccess
	, DATABASEPROPERTYEX('SplitLog', 'Status') AS Status
	
SELECT COUNT(*) FROM SplitLog.dbo.LargeTable

--		Step 4: Set database in multi user
ALTER DATABASE SplitLog SET MULTI_USER

SELECT DATABASEPROPERTYEX('SplitLog', 'UserAccess') AS UserAccess
	, DATABASEPROPERTYEX('SplitLog', 'Status') AS Status
	
-- Undo:
USE MASTER
DROP DATABASE SplitLog