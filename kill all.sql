USE [master]
GO
DECLARE @ProcessID int 
DECLARE @ProcessIDText Varchar(10)
DECLARE @SQL varchar(8000)
DECLARE @DBName varchar(20)
SET @DBName = 'MedicaidNet'          ------------ Write the database name



DECLARE curKillSPID CURSOR FAST_FORWARD
FOR
	SELECT sp.spid  AS SPID
	FROM sys.sysprocesses sp 
	WHERE sp.dbid = (SELECT sd.dbid FROM sys.sysdatabases sd where name = @DBName and spid > 50 )

OPEN curKillSPID

FETCH NEXT FROM curKILLSPID INTO @ProcessID 

WHILE @@FETCH_STATUS = 0 
BEGIN
    SELECT @ProcessIDText =  Convert (varchar, @ProcessID) 
	
	PRINT 'Kill ' + @ProcessIDText
	SET @SQL = 'KILL ' + @ProcessIDText 
	EXEC (@SQL)
	
	FETCH NEXT FROM curKILLSPID INTO @ProcessID

END

CLOSE curKILLSPID 

DEALLOCATE curKILLSPID 



