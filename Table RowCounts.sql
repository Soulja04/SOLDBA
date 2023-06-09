
SELECT 
  s.Name [Schema], 
  o.Name [Table], 
  p.row_count
FROM sys.dm_db_partition_stats p
INNER JOIN sys.objects as o
  ON o.object_id = p.object_id
INNER JOIN sys.schemas as s
  ON s.schema_id = o.schema_id
INNER JOIN sys.indexes as i
  ON i.object_id = p.object_id 
  AND i.index_id = p.index_id
  AND i.index_id IN (0,1) -- HEAP or CLUSTERED INDEX
WHERE 
  o.type_desc = 'USER_TABLE'
  AND o.is_ms_shipped = 0
  AND o.Name != 'sysdiagrams'

ORDER BY 
  o.Name
