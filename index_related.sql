-- Missing Indexes for all databases by Index Advantage  (Query 32) (Missing Indexes All Databases)
SELECT CONVERT(decimal(18,2), migs.user_seeks * migs.avg_total_user_cost * (migs.avg_user_impact * 0.01)) AS [index_advantage],
FORMAT(migs.last_user_seek, 'yyyy-MM-dd HH:mm:ss') AS [last_user_seek], 
mid.[statement] AS [Database.Schema.Table],
COUNT(1) OVER(PARTITION BY mid.[statement]) AS [missing_indexes_for_table],
COUNT(1) OVER(PARTITION BY mid.[statement], equality_columns) AS [similar_missing_indexes_for_table],
mid.equality_columns, mid.inequality_columns, mid.included_columns, migs.user_seeks, 
CONVERT(decimal(18,2), migs.avg_total_user_cost) AS [avg_total_user_cost], migs.avg_user_impact 
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK)
ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK)
ON mig.index_handle = mid.index_handle
ORDER BY index_advantage DESC OPTION (RECOMPILE);
------

-- Getting missing index information for all of the databases on the instance is very useful
-- Look at last user seek time, number of user seeks to help determine source and importance
-- Also look at avg_user_impact and avg_total_user_cost to help determine importance
-- SQL Server is overly eager to add included columns, so beware
-- Do not just blindly add indexes that show up from this query!!!
-- Håkan Winther has given me some great suggestions for this query




SELECT DB_NAME() AS DB
	,f.name
	,f.physical_name
	,u.*
FROM sys.dm_db_file_space_usage u
JOIN sys.database_files f ON u.file_id = f.file_id

-- Extent = 8 8kb pages


-- Find "large" objects with lots of scans and few seeks

SELECT OBJECT_NAME(u.object_id) AS OBJECT
	,u.index_id
	,u.user_seeks
	,u.user_scans
	,u.user_lookups
	,i.name
	,i.type_desc
FROM sys.dm_db_index_usage_stats u
JOIN sys.indexes i ON u.index_id = i.index_id
	AND u.object_id = i.object_id
WHERE u.object_id > 100
	AND OBJECT_NAME(u.object_id) IS NOT NULL
	AND u.user_scans > u.user_seeks
ORDER BY u.object_id
	,u.index_id

-- SELECT * FROM sys.dm_db_index_physical_stats(db_id(), object_id('Orders'), NULL, NULL , 'DETAILED')

SELECT OBJECT_NAME(x.object_id) AS Object
	, x.avg_fragmentation_in_percent
	, x.page_count
	, x.fragment_count
	, x.index_id
	, x.index_type_desc
	, x.record_count
	, x.avg_page_space_used_in_percent
	, x.avg_record_size_in_bytes
FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL , 'DETAILED') x
WHERE x.avg_fragmentation_in_percent > 50
	AND x.page_count > 10
ORDER BY x.page_count DESC
GO

----------
SELECT * 
FROM sys.dm_db_index_physical_stats(
	DB_ID()
	, DEFAULT
	, DEFAULT
	, DEFAULT
	, DEFAULT
) x
WHERE x.avg_fragmentation_in_percent > 50
GO

-- Find missing indexes:

SELECT grp.avg_user_impact
	,grp.last_user_seek
	,mid.[statement] AS [Database.Schema.Table]
	,mid.equality_columns
	,mid.inequality_columns
	,mid.included_columns
	,grp.unique_compiles
	,grp.user_seeks
	,grp.avg_total_user_cost
FROM sys.dm_db_missing_index_group_stats AS grp
JOIN sys.dm_db_missing_index_groups AS mig ON grp.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle
ORDER BY grp.avg_user_impact DESC

-----


------
ALTER INDEX index_name ON table_name REBUILD PARTITION = ALL
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,ONLINE = OFF
			,SORT_IN_TEMPDB = OFF
			)

---create indexes
CREATE CLUSTERED | NONCLUSTERED INDEX <INDEX_NAME>

ON <TABLE_NAME> (COLUMN_NAME ASC |DESC)

WITH

SORT_IN_TEMPDB = ON | OFF, -- SORTING IN MEMORY OR TEMPDB

FILL_FACTOR = 80, -- THIS IS TO AVOID/MIMIMIZE PAGE SPLIT WHENEVER WE HAVE INSERTION

PAD_INDEX = ON | OFF -- if on it means Apply FillFactor to all layers (root and intermediate level)


