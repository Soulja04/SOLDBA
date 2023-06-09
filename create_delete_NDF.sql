CREATE DATABASE MultipleFiles
Go
ALTER DATABASE MultipleFiles
ADD FILE (
	NAME=N'MultipleFiles02'
	, FILENAME=N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MultipleFiles02.ndf'
	, SIZE=30MB
	, MAXSIZE=100MB
	, FILEGROWTH=10%
)
GO
USE MultipleFiles
GO
SELECT * FROM sys.database_files
GO

CREATE TABLE BigTable (ColA CHAR(8000))
GO
INSERT BigTable VALUES ('A')
GO 10000

SELECT COUNT(*) FROM BigTable

GO

USE [MultipleFiles]
GO
-- Fails because there is data in the file!
ALTER DATABASE [MultipleFiles]  
REMOVE FILE [MultipleFiles03]
GO

-- Solution: move the data out of this file into the other data files
--				a.k.a. "Empty" the file

DBCC SHRINKFILE (N'MultipleFiles03' , EMPTYFILE)
GO
-- Removes the physical file from the system
-- Cannot recover from the trash!
ALTER DATABASE [MultipleFiles]  
REMOVE FILE [MultipleFiles03]
GO
