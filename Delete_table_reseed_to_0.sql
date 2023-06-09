
		---------------------------------------------------------------
------------------- Just Fill Parameters Value ----------------
---------------------------------------------------------------
DECLARE @DbName AS NVARCHAR(30) = 'db4_ee'         --< Db Name
DECLARE @Schema AS NVARCHAR(30) = 'dbo'          --< Schema
DECLARE @TableName AS NVARCHAR(50) = 'RENEWAL_REDETERMINATION_VERIFICATION'      --< Table Name
------------------ /Just Fill Parameters Value ----------------

DECLARE @Query AS NVARCHAR(500) = 'Delete FROM ' + @TableName

EXECUTE sp_executesql @Query
SET @Query=@DbName+'.'+@Schema+'.'+@TableName
DBCC CHECKIDENT (@TableName,RESEED, 0)






