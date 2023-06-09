-- What if you receive a backup from another DBA
-- and you need to restore it? 
--		What version is this from?
--		What backups are on this file?
--		Where will the database files be restored?
--		What types of backups are on this file?

-- The quick-and-dirty way to learn all of this 
--		is to create a backup device over the file

-- Step 1: Find the path to the backup file you want to learn about

-- Step 2: Decide on the RESTORE command to use
-- Label tells us the media set id + how many files make up a given backup
RESTORE LABELONLY FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'

-- All the backups in the file and we identify them with "Position"
	-- Backup type of 5 = DIFFERENTIAL
	-- Backup type of 1 = FULL
RESTORE HEADERONLY FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'

BACKUP DATABASE Chapter07
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'


RESTORE LABELONLY FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'
RESTORE HEADERONLY FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'

RESTORE VERIFYONLY FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'

 RESTORE VERIFYONLY FROM DISK = N'H:\Backups\Cares\MSVPIDCSQL01$CARES\Log\FULL\MSVPIDCSQL01$CARES_Log_FULL_20200126_032652.bak' WITH CHECKSUM