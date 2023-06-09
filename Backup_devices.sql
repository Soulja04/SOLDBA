-- This is not three copies of a backup
-- This is "striping" a backup across three files

BACKUP DATABASE [LearnItFirst171] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\File1.bak'
,  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\File2.bak'
,  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\File3.bak' WITH NOFORMAT, NOINIT,  NAME = N'LearnItFirst171-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

SELECT * FROM msdb.dbo.backupset

-- A backup file can contain:
--		* Multiple database backups (backups from diff. databases in same)
--		* Different types of backups (diff, full, log in the same file)
--		* We differentiate by "Position" column in dbo.backupset

SELECT s.name, s.database_name, s.backup_start_date
	, DATEDIFF(second, s.backup_start_date, s.backup_finish_date)
		AS Elapsed
	, CAST(s.backup_size/1024/1024 AS DECIMAL(10,2)) AS "Size (MB)"
	, CASE s.Type
		WHEN 'D' THEN 'Full'
		WHEN 'I' THEN 'Differential'
		ELSE 'Log'
	END AS BackupType
FROM msdb.dbo.backupset s

SELECT * FROM msdb.dbo.backupmediafamily

SELECT * FROM msdb.dbo.backupset
WHERE media_set_id = 2023

BACKUP DATABASE [Chapter07] 
TO  [Monday] 


