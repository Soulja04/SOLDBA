DECLARE @Spid int

DECLARE OpenConnections CURSOR
FOR
  SELECT sp.SPID
  FROM sysprocesses sp
  JOIN sysdatabases sd ON sp.DBID = sd.DBID
  WHERE sd.[Name] = 'LancelotProd'

OPEN OpenConnections
FETCH NEXT FROM OpenConnections
INTO @Spid
WHILE @@FETCH_STATUS = 0
BEGIN
  SELECT @Spid
  EXEC ('Kill ' + @Spid)
  FETCH NEXT FROM OpenConnections
  INTO @Spid
END
CLOSE OpenConnections
DEALLOCATE OpenConnections
