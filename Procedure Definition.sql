SELECT 
  p.name Procedure_Name,
  s.name Scheam_Name,
  m.definition TSQL   
FROM sys.procedures p
JOIN sys.sql_modules m
  ON p.object_id = m.object_id
JOIN sys.schemas s
  ON p.schema_id = s.schema_id  