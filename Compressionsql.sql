-- Backup compression is not enabled by default
-- Only available in Enterprise, B.I., Standard, Eval, Dev
RESTORE HEADERONLY 
FROM DISK = 'G:\IISLogs.bak'

-- Backup size:				25399766016
-- Compressed backup size:	3762590101	
SELECT 25399766016/1024/1024 AS [Size in MB - uncompressed]
	, 3762590101/1024/1024 AS [Size in MB - compressed]
	, 25399766016 / CAST(3762590101 AS DECIMAL(15,2)) AS Ratio

-- Uncompression:	24gb backup file
-- Compression:		3.5gb backup file

EXEC sp_configure 'show advanced', 1
RECONFIGURE
EXEC sp_configure 'backup compression default', 1 -- enabled
RECONFIGURE

RESTORE HEADERONLY 
FROM DISK = 
'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171_Compressed.bak'

/*
Pros of compression:
	-- Compressed backups take up less disk space
	-- Compressed backups often backup faster
	-- Compressed backups often restore faster

Cons of compression:
	-- NT backups cannot coexist on tape with a SQL Server compressed
	-- Edition support
	-- Media set must either be "all compressed" or "all uncomp."

*/

-- To backup using the default compression settings:
BACKUP DATABASE [LearnItFirst171] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171_Compressed.bak' 
WITH INIT
GO

-- To force backup compression:
BACKUP DATABASE [LearnItFirst171] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171_Compressed.bak' 
WITH INIT, COMPRESSION
GO


-- To force no backup compression regardless of default:
BACKUP DATABASE [LearnItFirst171] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171_Compressed.bak' 
WITH INIT, NO_COMPRESSION
GO

-- How to determine whether backup comp. is faster
DECLARE @StartTime DATETIME = GETDATE()
	, @Elapsed_Compression INT
	, @Elapsed_Uncompress INT

BACKUP DATABASE LearnitFirst171
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\Backup_Compressed.bak' 
WITH INIT, COMPRESSION

SET @Elapsed_Compression = DATEDIFF(second, @StartTime, GETDATE())

SET @StartTime = GETDATE()
BACKUP DATABASE LearnitFirst171
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\Backup_Uncompressed.bak' 
WITH INIT, NO_COMPRESSION

SET @Elapsed_Uncompress = DATEDIFF(second, @StartTime, GETDATE())

SELECT @Elapsed_Compression AS Compressed
	, @Elapsed_Uncompress AS Uncompressed

GO

-- To determine how much more a backup has before completion:
--		(1) Find the SPID of backup operation
--		(2) Look at the percent_complete column in sys.dm_exec_requests
SELECT @@SPID

RESTORE VERIFYONLY 
FROM DISK = 'G:\ProjectManagement_Uncompressed.bak'