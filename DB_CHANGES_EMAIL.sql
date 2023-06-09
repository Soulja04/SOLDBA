DECLARE @the_query VARCHAR(2048) = '
SELECT [PostTime], [Object], [TSQL]
	FROM dba.dbo.DatabaseLog
	WHERE PostTime BETWEEN (GETDATE() - 1) AND GETDATE()
'
EXEC msdb.dbo.sp_send_dbmail 
	@profile_name=N'CARES_Mail',
	@recipients=N'selamu.Abebe@cares.alabama.gov', 		
	@subject='CARES Database Change Report',
	@body =N'This report show the changes within the CARES database for the past 1 days.

	***** Please DO NOT REPLY to this automated message. *****
	'
	, @query=@the_query
	, @attach_query_result_as_file = 1;