
--http://www.mssqltips.com/tip.asp?tip=2070


EXEC xp_servicecontrol N'querystate',N'MSSQLServer'
EXEC xp_servicecontrol N'querystate',N'SQLServerAGENT'
EXEC xp_servicecontrol N'querystate',N'msdtc'
EXEC xp_servicecontrol N'querystate',N'sqlbrowser'
EXEC xp_servicecontrol N'querystate',N'MSSQLServerOLAPService'
EXEC xp_servicecontrol N'querystate',N'ReportServer'


------Database status in suspect or restoring state

select name,databasepropertyex(name, 'status') [status]  from sysdatabases
select name from sys.databases where state_desc <> 'online'