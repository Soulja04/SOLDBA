CREATE PROC Sp_TableBackup(@tblname NVARCHAR(100))    
AS    
DECLARE @SQL NVARCHAR(MAX)    
DECLARE @DT VARCHAR(10)    
SELECT @DT = REPLACE((CONVERT(VARCHAR(10),GETDATE(),110)),'-','_')     
SET @SQL='SELECT * INTO '+@tblname+'_'+@DT + ' FROM '+@tblname    
PRINT @SQL    
EXECUTE(@SQL)