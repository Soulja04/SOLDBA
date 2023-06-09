CREATE TABLE dbo.Table1 (
    id INT
    ,fname VARCHAR(100)
    ,lname VARCHAR(100)
    ,address VARCHAR(50)
    )
GO

CREATE TABLE dbo.Table2 (
    id INT
    ,NAME VARCHAR(100)
    ,address VARCHAR(50)
    )
--Let's run below query after providing the Schema Names and Table Names. 
--Provide the Schema and Table Names for comparison
DECLARE @Table1Schema VARCHAR(50) = 'dbo'
DECLARE @Table2Schema VARCHAR(50) = 'dbo'
DECLARE @Table1Name VARCHAR(50) = 'Table1'
DECLARE @Table2Name VARCHAR(50) = 'table2'

;

WITH CTE1
AS (
    SELECT *
    FROM information_schema.columns
    WHERE table_schema = @Table1Schema
        AND table_name = @Table1Name
    )
    ,CTE2
AS (
    SELECT *
    FROM information_schema.columns
    WHERE table_schema = @Table2Schema
        AND table_name = @Table2Name
    )
SELECT
    --cte1.Table_Schema,cte1.Table_Name,cte1.Column_Name,
    --cte2.Table_Schema,cte2.Column_Name,cte2.Table_Name,
    IsNull(cte1.Column_Name, cte2.Column_Name) AS ColumnName
    ,CASE 
        WHEN cte1.Column_Name = cte2.Column_Name
            THEN 'Exists in Both Tables ( ' + @Table1Name + ' , ' + @Table2Name + ' )'
        WHEN cte1.Column_Name IS NULL
            THEN 'Does not Exists in ' + @Table1Name
        WHEN cte2.Column_Name IS NULL
            THEN 'Does not Exists in ' + @Table2Name
        END AS IsMatched
FROM CTE1
FULL JOIN cte2 ON cte1.Column_Name = cte2.Column_Name