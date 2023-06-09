EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
EXEC sp_configure 'AGENT XPs', 1
GO
RECONFIGURE
GO
EXEC sp_configure 'show advanced options', 0
go
RECONFIGURE
GO

