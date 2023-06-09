/*
	While the SQL Server service is running,
	it has exclusive access to the databases'
	files.
*/
CREATE DATABASE DetachMe
GO
SELECT * 
FROM sys.master_files x 
WHERE DB_NAME(x.database_id) = N'DetachMe'
GO

EXEC master.dbo.sp_detach_db 
	@dbname = N'DetachMe'
GO
-- old school: EXEC sp_attach_db (deprecated!)
CREATE DATABASE [DetachMeNowAttached] ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DetachMe.mdf' )
,( FILENAME = N'F:\DetachMe_log.ldf' )
 FOR ATTACH
GO

CREATE DATABASE NoLog
GO
EXEC sys.sp_detach_db N'NoLog';


CREATE DATABASE NoLog ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\NoLog.mdf' )
 FOR ATTACH_REBUILD_LOG -- creates a new transaction log if you've 'lost' the original!
GO



ALTER DATABASE [CHIP] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
EXEC master.dbo.sp_detach_db 
	@dbname = N'CHIP'
GO
