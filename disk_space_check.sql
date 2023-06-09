



/*This script will get the information of drives having free percentage 
less than or equal to 10 % (on all servers that are registered)*/


SELECT distinct(volume_mount_point), 
   (select ((available_bytes/1048576* 1.0)/(total_bytes/1048576* 1.0) *100)) as FreePercentage
FROM sys.master_files AS f CROSS APPLY 
  sys.dm_os_volume_stats(f.database_id, f.file_id)
  where ((available_bytes/1048576* 1.0)/(total_bytes/1048576* 1.0) *100) <= 10
group by volume_mount_point, total_bytes/1048576, 
  available_bytes/1048576 order by 1





  -----------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DBA_DiskSpaceMntr]
AS
BEGIN

declare @DiskFreeSpace int;
declare @mailbody nvarchar(4000);
declare @MailSubject nvarchar(1000);
declare @sub nvarchar(4000);
declare @cmd nvarchar(4000);
DECLARE @HDrivethreshold INT 
DECLARE @mailto nvarchar(max)
DECLARE @Freespaceleft1 VARCHAR(max)
DECLARE @Freespaceleft2 VARCHAR(max)
DECLARE @Freespaceleft3 VARCHAR(max)
DECLARE @datetime DATETIME=getdate();

set nocount on
IF EXISTS(select * from sys.sysobjects where id = object_id('#driveinfo'))
	drop table #driveinfo
create table #driveinfo(id int identity(1,1),drive char(1), fspace int)
insert into #driveinfo EXEC master..xp_fixeddrives
SELECT @DiskFreeSpace = fspace FROM #driveinfo where drive in ('H')
SELECT @HDrivethreshold = total_bytes/(1024*1024) FROM sys.dm_os_volume_stats(21,2)
SET @Freespaceleft1 = @HDrivethreshold-((@HDrivethreshold*80)/100)
SET @Freespaceleft2 = @HDrivethreshold-((@HDrivethreshold*70)/100)
SET @Freespaceleft3 = @HDrivethreshold-((@HDrivethreshold*5)/100)
IF @DiskFreeSpace < @Freespaceleft1
BEGIN
SET @MailSubject = 'Drive H: free space is low on ' + CAST(SERVERPROPERTY('Machinename') AS NVARCHAR)+ CONVERT (VARCHAR,@datetime ,120)
SET @mailbody = 'Drive H: on ' + CAST(SERVERPROPERTY('Machinename') AS NVARCHAR) + ' has only ' +  CAST(@DiskFreeSpace AS NVARCHAR) + ' MB free space out of '+CAST(@HDrivethreshold AS VARCHAR)+' MB , which is less than 80% of total disk space. Please free up space on this drive.'
SET @mailto = 'sahaja.madineni@cares.alabama.gov' 
EXEC msdb.dbo.sp_send_dbmail 
@profile_name = 'CARES_mail',
@recipients= @mailto,--cares-sql-alert@cares.alabama.gov
@subject = @MailSubject,
@body = @mailbody,
--@file_attachments = @logfile,
@body_format = 'HTML' 
END

ELSE IF @DiskFreeSpace < @Freespaceleft2
BEGIN
SET @MailSubject = 'Drive H: free space is low on ' + CAST(SERVERPROPERTY('Machinename') AS NVARCHAR)+ CONVERT (VARCHAR,@datetime ,120)
SET @mailbody = 'Drive H: on ' + CAST(SERVERPROPERTY('Machinename') AS NVARCHAR) + ' has only ' +  CAST(@DiskFreeSpace AS VARCHAR) + ' MB free space out of '+CAST(@HDrivethreshold AS NVARCHAR)+' MB , which is less than 70% of total disk space. Please free up space on this drive.'
SET @mailto = 'sahaja.madineni@cares.alabama.gov'
EXEC msdb.dbo.sp_send_dbmail 
@profile_name = 'CARES_mail',
@recipients= @mailto,--cares-sql-alert@cares.alabama.gov
@subject = @MailSubject,
@body = @mailbody,
--@file_attachments = @logfile,
@body_format = 'HTML' 
END

ELSE IF @DiskFreeSpace < @Freespaceleft3
BEGIN
SET @MailSubject = 'Drive H: free space is low on ' + CAST(SERVERPROPERTY('Machinename') AS NVARCHAR)+ CONVERT (VARCHAR,@datetime ,120)
SET @mailbody = 'Drive H: on ' + CAST(SERVERPROPERTY('Machinename') AS NVARCHAR) + ' has only ' +  CAST(@DiskFreeSpace AS VARCHAR) + ' MB free space out of '+CAST(@HDrivethreshold AS NVARCHAR)+' MB , which is less than 10% of total disk space. Please free up space on this drive.'
SET @mailto = 'sahaja.madineni@cares.alabama.gov'
EXEC msdb.dbo.sp_send_dbmail 
@profile_name = 'CARES_mail',
@recipients= @mailto,--cares-sql-alert@cares.alabama.gov
@subject = @MailSubject,
@body = @mailbody,
--@file_attachments = @logfile,
@body_format = 'HTML' 
END


END



GO


