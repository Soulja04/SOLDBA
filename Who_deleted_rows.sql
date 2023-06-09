SELECT 
    [Transaction ID],
	[Begin Time],
    Operation,
    Context,
    AllocUnitName
	
FROM 
    fn_dblog(NULL, NULL) 
WHERE 
    Operation = 'LOP_DELETE_ROWS'

---then put the Transaction ID and run below query
	SELECT
    Operation,
    [Transaction ID],
    [Begin Time],
    [Transaction Name],
    [Transaction SID]
FROM
    fn_dblog(NULL, NULL)
WHERE
    [Transaction ID] = '0000:5bd82727'
AND
    [Operation] = 'LOP_BEGIN_XACT'



	---put the sid and run below query to see the login
	USE MASTER
GO   
SELECT SUSER_SNAME(0x0105000000000005150000005C315B85089B7C33B3053691A3060000)



----to find who dropped table or object
SELECT [Begin Time]
      ,[Transaction Name]
      ,SUSER_SNAME ([Transaction SID]) AS [User]
FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] = N'DROPOBJ';
GO


------------------------to find what operation filter can be used
SELECT
[Operation],
count(*) AS [No of Records],
SUM([Log Record Length]/1024.00/1024.00) AS [RecordSize (MB)]
FROM fn_dblog(NULL,NULL)
GROUP BY Operation
ORDER BY [RecordSize (MB)] DESC
