SELECT
SCHEMA_NAME(tbl.schema_id) AS [Schema],
tbl.name AS [Name],
tbl.object_id AS [ID]
FROM
sys.tables AS tbl
LEFT OUTER JOIN sys.periods as periods ON periods.object_id = tbl.object_id
LEFT OUTER JOIN sys.tables as historyTable ON historyTable.object_id = tbl.history_table_id
WHERE
(tbl.name not like '#%')
ORDER BY
[Schema] ASC,[Name] ASC