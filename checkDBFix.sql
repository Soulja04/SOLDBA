/*
	DBCC CHECKDB checks the entire database for logical and/or
		physical corruption. 

*/
DBCC CHECKDB(LearnItFirst)
DBCC CHECKDB(LearnItFirst) WITH NO_INFOMSGS -- 80gb 11 minutes
DBCC CHECKDB(LearnItFirst, NOINDEX)			-- 80gb 10 seconds
DBCC CHECKDB(LearnItFirst) WITH PHYSICAL_ONLY

USE Corrupt2012Database
GO
CReATE TABLE MyTable (ColA INT)
INSERT MyTable VALUES (1), (2), (4)
SELECT * FROM MyTable


DBCC CHECKDB(Corrupt2012Database) WITH NO_INFOMSGS
DBCC CHECKDB(Corrupt2012Database) WITH PHYSICAL_ONLY
DBCC CHECKDB(Corrupt2012Database, NOINDEX) WITH NO_INFOMSGS

-- To resolve: (a) restore from backup, (b) repair with DBCC

ALTER DATABASE Corrupt2012Database SET SINGLE_USER
GO
DBCC CHECKDB(Corrupt2012Database, REPAIR_REBUILD) -- highest level "fix". No possibility of data loss

DBCC CHECKDB(Corrupt2012Database) WITH NO_INFOMSGS

DBCC CHECKDB(Corrupt2012Database, REPAIR_ALLOW_DATA_LOSS)

ALTER DATABASE Corrupt2012Database SET MULTI_USER
GO
-- To speed up CHECKDB, consider trace flag 2549 with PHYSICAL_ONLY
GO
USE master
GO
DROP DATABASE Corrupt2012Database