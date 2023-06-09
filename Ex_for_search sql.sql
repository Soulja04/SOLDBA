CREATE EVENT SESSION [search] ON SERVER 
ADD EVENT SQLSatellite.failed_launching(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username)),
ADD EVENT sqlserver.database_transaction_begin(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username)),
ADD EVENT sqlserver.database_transaction_end(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username)),
ADD EVENT sqlserver.error_reported(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username)),
ADD EVENT sqlserver.errorlog_written(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username)),
ADD EVENT sqlserver.file_read(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username)),
ADD EVENT sqlserver.file_written(
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.request_id,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.server_principal_sid,sqlserver.session_id,sqlserver.session_resource_group_id,sqlserver.session_server_principal_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.transaction_sequence,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'search')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO


