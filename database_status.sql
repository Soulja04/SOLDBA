SELECT  name FROM sys.sysdatabases 
WHERE NOT status & 512 = 512

SELECT * FROM sys.databases db 
WHERE db.state = 0 

SELECT (columns) FROM sys.databases WHERE state = 0

select * from sys.databases db where db.state = 6

select name from sys.sysdatabases WHERE not status & 512 = 512
0 = ONLINE
1 = RESTORING
2 = RECOVERING
3 = RECOVERY_PENDING
4 = SUSPECT
5 = EMERGENCY
6 = OFFLINE

select name,databasepropertyex(name, 'status') [status]  from sysdatabases 

-------------------------
SELECT 
  d.name [DatabaseName],
  d.database_id,
  mf.file_id,
  mf.name,
  mf.physical_name,
  mf.size /128 [SizeInMB],
  CASE 
    WHEN mf.max_size <> -1 THEN mf.max_size / 128 
    ELSE mf.max_size
  END [MaxSizeInMB],
  mf.growth,
  mf.is_percent_growth,
  mf.state_desc 
FROM sys.master_files mf
JOIN sys.databases d
  ON mf.database_id = d.database_id
