USE master;  
GO  
ALTER DATABASE tempdb   
MODIFY FILE (NAME = tempdev, FILENAME = 'D:\Program Files\Microsoft SQL Server\MSSQL13.CARES\MSSQL\DATA\tempdb.mdf');  
GO  
ALTER DATABASE tempdb   
MODIFY FILE (NAME = templog, FILENAME = 'D:\Program Files\Microsoft SQL Server\MSSQL13.CARES\MSSQL\DATA\templog.ldf');  
GO

ALTER DATABASE tempdb   
MODIFY FILE (NAME = temp2, FILENAME = 'D:\Program Files\Microsoft SQL Server\MSSQL13.CARES\MSSQL\DATA\tempdb_mssql_2.ndf');  
GO


ALTER DATABASE tempdb   
MODIFY FILE (NAME = temp3, FILENAME = 'D:\Program Files\Microsoft SQL Server\MSSQL13.CARES\MSSQL\DATA\tempdb_mssql_3.ndf');  
GO

ALTER DATABASE tempdb   
MODIFY FILE (NAME = temp4, FILENAME = 'D:\Program Files\Microsoft SQL Server\MSSQL13.CARES\MSSQL\DATA\tempdb_mssql_4.ndf');  
GO

ALTER DATABASE tempdb   
MODIFY FILE (NAME = temp5, FILENAME = 'D:\Program Files\Microsoft SQL Server\MSSQL13.CARES\MSSQL\DATA\tempdb_mssql_5.ndf');  
GO


----------------------
SELECT name, physical_name AS CurrentLocation  
FROM sys.master_files  
WHERE database_id = DB_ID(N'tempdb');  
GO  

---------to start the server with master only recovery
--NET START MSSQL$instancename /f /T3608

-------to drop all NDF files replace logical name
USE [tempdb];
GO
DBCC SHRINKFILE (logicalname, EMPTYFILE);
GO
DBCC DROPCLEANBUFFERS
GO
DBCC FREEPROCCACHE
GO
DBCC FREESESSIONCACHE
GO
DBCC FREESYSTEMCACHE ( 'ALL')
GO
ALTER DATABASE [tempdb] REMOVE FILE [logicalname]
GO

------------------

--Make sure to set auto growth all files on the file group.

ALTER DATABASE [tempdb] MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES
--So to make the files the same size I would shrink tempdev to 30000MB like the rest of the files. 
---I would do that in in crements so the shrink can be stoped and restarted without the work so far wasted.

USE [tempdb]
DECLARE @FileName sysname = N'tempdev';
DECLARE @TargetSize INT = (SELECT 1 + size*8./1024 FROM sys.database_files WHERE name = @FileName);
DECLARE @Factor FLOAT = .999;
 
WHILE @TargetSize > 30000
BEGIN
    SET @TargetSize *= @Factor;
    DBCC SHRINKFILE(@FileName, @TargetSize);
    DECLARE @msg VARCHAR(200) = CONCAT('Shrink file completed. Target Size: ', 
         @TargetSize, ' MB. Timestamp: ', CURRENT_TIMESTAMP);
    RAISERROR(@msg, 1, 1) WITH NOWAIT;
    WAITFOR DELAY '00:00:01';
END;
---If I got blocked by a page I would try to see if it is anything I could release.

USE [tempdb]
GO
DBCC DROPCLEANBUFFERS
GO
DBCC FREEPROCCACHE
GO
DBCC FREESESSIONCACHE
GO
DBCC FREESYSTEMCACHE ( 'ALL')
GO
----And then I would start the shrink again.

----If it is still blocked by a page, then I would set the initial file size 
----so the file will be the same size after next sql service restart.

ALTER DATABASE TempDB MODIFY FILE
(NAME = tempdev, SIZE = 30000MB )
GO