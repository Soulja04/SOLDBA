--To Find out fragmentation level of a given database
--This query will give DETAILED information
--CAUTION : It may take very long time, depending on the number of tables in the DB
USE staging
GO
SELECT object_name(IPS.object_id) AS [TableName], 
   SI.name AS [IndexName], 
   IPS.Index_type_desc, 
   IPS.avg_fragmentation_in_percent, 
   IPS.avg_fragment_size_in_pages, 
   IPS.avg_page_space_used_in_percent, 
   IPS.record_count, 
   IPS.ghost_record_count,
   IPS.fragment_count, 
   IPS.avg_fragment_size_in_pages
FROM sys.dm_db_index_physical_stats(db_id(N'AdventureWorks'), NULL, NULL, NULL , 'DETAILED') IPS
   JOIN sys.tables ST WITH (nolock) ON IPS.object_id = ST.object_id
   JOIN sys.indexes SI WITH (nolock) ON IPS.object_id = SI.object_id AND IPS.index_id = SI.index_id
WHERE ST.is_ms_shipped = 0
ORDER BY 1,5
GO

/*
SELECT db_name(db_id()) as DBName,object_name(IPS.object_id) AS [TableName], 
    SI.name AS [IndexName], 
    IPS.Index_type_desc, 
    IPS.avg_fragmentation_in_percent, 
    IPS.avg_fragment_size_in_pages, 
    IPS.avg_page_space_used_in_percent, 
    IPS.record_count, 
    IPS.ghost_record_count,
    IPS.fragment_count, 
    IPS.avg_fragment_size_in_pages
FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL , 'DETAILED') IPS
    Inner Join sys.tables ST 
        ON IPS.object_id = ST.object_id
    Inner Join sys.indexes SI 
        ON IPS.object_id = SI.object_id AND IPS.index_id = SI.index_id
WHERE ST.is_ms_shipped = 0
ORDER BY IPS.avg_fragmentation_in_percent desc,TableName
GO

*/


--DBCC CHECKDB(SharePoint_Config)
/*
SELECT * FROM sys.sysindexes
SELECT * FROM sys.indexes
*/

DBCC SHOWCONTIG WITH TABLERESULTS, ALL_INDEXES, FAST