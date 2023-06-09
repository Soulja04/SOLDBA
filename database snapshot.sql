create database AdventureWorks_dbss on
(name = AdventureWorks2012_Data, 
filename = 'C:\backups\AdventureWorks_snap.ss')
as snapshot of [AdventureWorks2012]
go


use master
go

restore database [AdventureWorks2012]
from database_snapshot = 'AdventureWorks_dbss'
go