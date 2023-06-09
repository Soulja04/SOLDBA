--Data Type for all columns

SELECT   SchemaName = c.table_schema,
         TableName = c.table_name,
         ColumnName = c.column_name,
         DataType = data_type,
              max_length = c.CHARACTER_MAXIMUM_LENGTH
FROM     information_schema.columns c
         INNER JOIN information_schema.tables t
           ON c.table_name = t.table_name
              AND c.table_schema = t.table_schema
              AND t.table_type = 'BASE TABLE'
ORDER BY SchemaName,
         ColumnName



----------------------------------By column\table ----------

		 SELECT o.name AS objectname,
c.name AS Columnname ,
TYPE_NAME(c.user_type_id) AS datatype
FROM sys.objects AS o
 JOIN sys.columns AS c
ON o.object_id = c. object_id
WHERE o.Schema_id = SCHEMA_ID('dbo')---- o.name = 'FH_SSA_COMPOSITE_RESPONSE'--this is(tblname)
AND c.name = 'PERSON_ID'
