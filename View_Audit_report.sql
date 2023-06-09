

SELECT TOP 10 server_instance_name
	,event_time
	,action_id
	,session_id
	,session_server_principal_name AS UserName
	,database_name
	,object_name
	,statement
FROM sys.fn_get_audit_file('d:\MSSQL_Audits\AC_BALANCE_ADJUSTMENT_DETAIL_24B5AB40-B57E-4D79-BB4B-A349995FD325_0_133157141493600000.sqlaudit', DEFAULT, DEFAULT)
--WHERE action_id IN ( 'SL', 'IN', 'DR', 'LGIF' , '%AU%' )
GO

