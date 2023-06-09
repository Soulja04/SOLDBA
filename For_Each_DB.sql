
DECLARE @command varchar(2000) 
SELECT @command = 'IF ''?'' NOT IN(''master'',''model'',''msdb'',''tempdb'') Begin Use ? DBCC Shrinkfile(2,100)  END' 
EXEC sp_MSforeachdb @command