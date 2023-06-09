SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT o.name AS table_name
      ,i.name AS index_name 
      ,s.user_seeks
	  ,s.user_scans
	  ,s.user_lookups
	  ,s.user_updates
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON i.index_id = s.index_id
	AND s.object_id = i.object_id
INNER JOIN sys.objects o ON s.object_id = o.object_id
INNER JOIN sys.schemas c ON o.schema_id = c.schema_id
WHERE o.name = 'Application_Log'

------
DECLARE @Tablename VARCHAR(100) = '[dbo].[Application_Log]'
SELECT index_id,object_id, name FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(@tablename)


SELECT
*
FROM
[sys].[dm_db_index_usage_stats] [ddius]
CROSS APPLY [sys].[dm_db_index_operational_stats]
([ddius].[database_id],
[ddius].[object_id],
[ddius].[index_id],
NULL) [ddios]
WHERE [ddius].[database_id] = 7

------
dbo.sp_BlitzIndex @DatabaseName = N'DB4_ee', -- nvarchar(128)
                  @Mode = 0,           -- tinyint
                  @SchemaName = N'dbo',   -- nvarchar(128)
                  @TableName = N'AT_PERSON',    -- nvarchar(128)
                  @Filter = 0          -- tinyint