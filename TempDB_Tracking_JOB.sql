USE [msdb]
GO

/****** Object:  Job [TempDB Tacking]    Script Date: 5/23/2022 9:38:07 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 5/23/2022 9:38:07 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'TempDB Tacking', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'MS-MEDICAID\svc.sqlp.ag.cares', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Check_Replica]    Script Date: 5/23/2022 9:38:08 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Check_Replica', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=1, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF EXISTS (
           SELECT 1 
		   FROM sys.dm_hadr_availability_replica_states AS ars
		   INNER JOIN sys.dm_hadr_database_replica_states AS drs
		   ON drs.group_id = ars.group_id
		   WHERE ars.is_local = 1
		       AND
			   ars.role_desc = ''SECONDARY''
          )
    RAISERROR(''This instance is a secondary replica jobs can not be executed on this replica.'', 16, 1)
	ELSE PRINT (''This IS A PRIMARY REPLICA'')', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [TempDB Sniffing]    Script Date: 5/23/2022 9:38:08 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'TempDB Sniffing', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=4, 
		@on_success_step_id=3, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dba.[dbo].[TempDBSniffing]', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [TempDB Size]    Script Date: 5/23/2022 9:38:08 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'TempDB Size', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE tempdb
GO

INSERT INTO dba.[dbo].[tempdbsize]
(
    [SpaceUsedMB],
    [SpaceCurrentMB],
    [SpaceFreeMB],
    [timestamp]
)
SELECT SUM(A.usedSpaceMB) SpaceUsedMB,
       SUM(A.CurrentSizeMB) SpaceCurrentMB,
       SUM(A.FreeSpaceMB) SpaceFreeMB,
       GETDATE() AS timestamp
FROM
(
    SELECT DB_NAME() AS DbName,
           name AS FileName,
           size / 128.0 AS CurrentSizeMB,
           size / 128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) / 128.0 AS FreeSpaceMB,
           (size / 128.0 - (size / 128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) / 128.0)) AS usedSpaceMB
    FROM sys.database_files
    WHERE name <> ''templog''
) AS A;', 
		@database_name=N'tempdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'every 30 seconds', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190219, 
		@active_end_date=99991231, 
		@active_start_time=210000, 
		@active_end_time=20000, 
		@schedule_uid=N'c0dfa15e-a22f-4a12-add9-45e7e7eba832'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


