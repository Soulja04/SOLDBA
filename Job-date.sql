select @@servername -- this should be on the same server as the job
exec  msdb.dbo.sp_help_job @job_name = 'jobname'

select * from
msdb.dbo.sysjobs
where name ='jobname'


set nocount on

declare @job_id uniqueidentifier = 'jobid--------A-9A7B64A69B20'
declare @step_id int = 1
declare @command NVARCHAR(MAX)
declare @sql NVARCHAR(MAX)


--a quick select just to check
    SELECT step_id,
           step_name,
           subsystem,
           command,
           output_file_name,
           proxy_id
    FROM msdb.dbo.sysjobsteps
    WHERE (job_id = @job_id)
      AND ((@step_id IS NULL) OR (step_id = @step_id))
    ORDER BY job_id, step_id

--REPLACE(string, old_string, new_string)

    SELECT @COMMAND = replace(command,'2019-02-27','1900-01-01')
    FROM msdb.dbo.sysjobsteps
    WHERE (job_id = @job_id)
      AND ((@step_id IS NULL) OR (step_id = @step_id))
    ORDER BY job_id, step_id

print @command

SET @SQL =
'
EXEC msdb.dbo.sp_update_jobstep 
@job_id=N''' +  'jobid--------A-9A7B64A69B20' + ''',' + '
@step_id=1 , ' +
'@command=N''' + @command + '' + char(39) 

print @sql

exec sp_executesql @sql

