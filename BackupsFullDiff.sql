-- BACKUP DATABASE - Full and differential
-- BACKUP LOG - Transation log

-- Full backup of LearnItFirst171:
BACKUP DATABASE LearnItFirst171
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'

-- Another full backup (default is append to file - NOINIT):
BACKUP DATABASE LearnItFirst171
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'

-- To overwrite the file:
BACKUP DATABASE LearnItFirst171
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'
WITH INIT

-- NOINIT
BACKUP DATABASE LearnItFirst171
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'
WITH NOINIT

-- Take a differential (changes since last full)
BACKUP DATABASE LearnItFirst171
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'
WITH DIFFERENTIAL

-- Take a differential named 'Oopsie!'
BACKUP DATABASE LearnItFirst171
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\LearnItFirst171.bak'
WITH DIFFERENTIAL, NAME = 'Oopsie!', INIT

-- Once SQL Server has finished taking the backup, it removes all 
-- "hooks" into that backup file. This is now a regular "file" in the 
-- file system (it's no longer a SQL Server file). 