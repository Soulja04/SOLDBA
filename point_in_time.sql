/*
	Full
	Diff
	Diff
	Log
	Log
	Diff
	Add 1 row (11401 total rows)

	RESTORE HEADERONLY FROM DISK = 'Chapter07.bak'

	A backup file can contain multiple backups. We
	address those files individually with the Position 
	column.
	
	Typically point-of-last-backup restore sequence:
	Restore most recent full (Position = 1)
	Restore most recent diff (Position = 6)
	Restore all logs since this last diff (none)
	
	Typically point-of-failure or point-in-time restore sequence:
	Backup the tail log
	Restore most recent full (Position = 1)
	Restore most recent diff (Position = 6)
	Restore all logs since this last diff (Position = 7)
*/
-- Example point-of-last-backup restore:

-- Restore most recent full (Position = 1)
RESTORE DATABASE Chapter07
FROM DISK = 'Chapter07.bak'
WITH FILE = 1, NORECOVERY, REPLACE -- overwrites the database and skips the tail log backup requirement

-- Restore most recent diff (Position = 6)
RESTORE DATABASE Chapter07
FROM DISK = 'Chapter07.bak'
WITH FILE = 6
GO
SELECT COUNT(*) FROM Chapter07.dbo.BigTable

/***********************************************/
-- Example of a point-of-failure or point-in-time restore:

-- Take a tail log backup
BACKUP LOG Chapter07
TO DISK = 'Chapter07.bak'
WITH NOINIT, Name = 'Tail log backup'
GO
RESTORE HEADERONLY FROM DISK = 'Chapter07.bak'

-- Restore most recent full (Position = 1)
RESTORE DATABASE Chapter07
FROM DISK = 'Chapter07.bak'
WITH FILE = 1, NORECOVERY, REPLACE

-- Restore most recent diff (Position = 6)
RESTORE DATABASE Chapter07
FROM DISK = 'Chapter07.bak'
WITH FILE = 6, NORECOVERY

-- Restore the tail log (Position = 7)
RESTORE LOG  Chapter07
FROM DISK = 'Chapter07.bak'
WITH FILE = 7

SELECT COUNT(*) FROM Chapter07.dbo.BigTable