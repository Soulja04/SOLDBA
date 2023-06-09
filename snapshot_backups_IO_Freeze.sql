SELECT bs.database_name,
  DATEDIFF(SECOND,bs.backup_start_date,bs.backup_finish_date)ASduration_seconds,
  bs.backup_start_date,bs.backup_finish_date,bs.backup_size
FROM msdb.dbo.backupset bs
WHERE bs.type='D'
AND bs.compressed_backup_size>=20000000000/* At least 50GB */
AND DATEDIFF(SECOND,bs.backup_start_date,bs.backup_finish_date)<=60/* Backup took less than 60 seconds */
AND bs.backup_finish_date>=DATEADD(DAY,-14,GETDATE())/* In the last 2 weeks */
ORDER BY bs.backup_finish_date DESC