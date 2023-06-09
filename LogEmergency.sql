CREATE DATABASE [LogFillUp]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LogFillUp', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\LogFillUp.mdf' , SIZE = 30720KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'LogFillUp_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\LogFillUp_log.ldf' , SIZE = 30720KB , FILEGROWTH = 0)
GO
ALTER DATABASE [LogFillUp] SET RECOVERY FULL 
GO
USE LogFillUp
GO
CREATE TABLE MemberNote (Note CHAR(8000))
GO
-- Take first backup so that we are actually in FULL recovery model:
BACKUP DATABASE LogFillUp TO DISK = 'LogFillUp.bak'

SET NOCOUNT ON

-- Lots of transactions with no backup of the log:
INSERT MemberNote VALUES ('A note')
GO 2000

DBCC SQLPERF(logspace)

INSERT MemberNote VALUES ('A note')
GO 500

INSERT MemberNote VALUES ('A note')
GO 500

INSERT MemberNote VALUES ('A note')
GO 500

/*
	When the log is 100% full, by default auto-growth kicks in.
		- Sometimes auto-growth is disabled (in this case)
		- Sometimes the disk is full

	When the log is 100% full and cannot grow, the database
	is now read-only

	Ways that the log can get to this point:
		- Long-running/open transaction
		- If you aren't taking transaction log backups
		- Log file set to manual growth and has reached max size
		- Disk could be full (autogrowth cannot happen)

	After you "control" your log (by clearing some space), consider
	shrinking the log file if it has auto-grown to a too-large size

*/
SELECT name, log_reuse_wait_desc FROM sys.databases

-- These all fail because they are logged:
DELETE MemberNote
TRUNCATE TABLE MemberNote
DROP TABLE MemberNote

-- How to determine whether or not your log is getting full due to 
--	a long running transaction:
DBCC OPENTRAN

-- If you aren't taking transaction log backups, take one!
--	Make sure you store this log backup with your other backups
DBCC SQLPERF(logspace)

-- Careful: this may take hours!
BACKUP LOG LogFillUp TO DISK = 'LogFillUp_Log.bak'

INSERT MemberNote VALUES ('A new note')
GO 2000

-- Worst-case scenario in which to get the database to be read/write
-- ASAP, switch the database to SIMPLE recovery model
ALTER DATABASE LogFillUp
SET RECOVERY SIMPLE
GO
CHECKPOINT
GO
DBCC SQLPERF(logspace)
-- This will break your restore chain! Once you do this, switch back to
-- full, re-size the log file (if necessary), then take a full backup