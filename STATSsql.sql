
--- CHECK LAST TIME STATS WERE UPDATED
USE Db4_ee
GO
SELECT name AS index_name,
STATS_DATE(OBJECT_ID, index_id) AS StatsUpdated
FROM sys.indexes
WHERE OBJECT_ID = OBJECT_ID('[dbo].[AC_BALANCE_ADJUSTMENT_DETAIL]')
GO
---
DBCC SHOW_STATISTICS ( AC_BALANCE_ADJUSTMENT_DETAIL , [IX_AC_BALANCE_ADJUSTMENT_DETAIL__AC_BALANCE_ADJUSTMENT_ID] )  
GO
---- create stats
CREATE STATISTICS Customer_LastName   
ON AdventureWorksPDW2012.dbo.DimCustomer (LastName);  
GO  

---TO UPDATE STATS
USE Db4_ee;
GO
UPDATE STATISTICS AC_BALANCE_ADJUSTMENT_DETAIL
WITH FULLSCAN
GO



-------
DECLARE @TSQL nvarchar(2000)

-- Filtering system databases from execution
SET @TSQL = '
IF DB_ID(''?'') > 4
BEGIN
   USE [?]; exec sp_updatestats
END
'
-- Executing TSQL for each database
EXEC sp_MSforeachdb @TSQL

-------
DECLARE @TSQL nvarchar(2000)

-- Filtering system databases and user databases from execution
SET @TSQL = '
IF (DB_ID(''?'') > 4
   AND ''?'' NOT IN(''distribution'',''SSISDB'',''ReportServer'',''ReportServertempdb'')
   )
BEGIN
   PRINT ''********** Rebuilding statistics on database: [?] ************''
   USE [?]; exec sp_updatestats
END
'
-- Executing TSQL for each database
EXEC sp_MSforeachdb @TSQL
