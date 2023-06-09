select * from  sys.dm_exec_query_stats
select * from  sys.dm_exec_query_stats order by creation_time desc
select * from  sys.dm_exec_query_stats order by total_worker_time desc
select * from  sys.dm_exec_query_plan (0x0600110075AFCC06903C543ECF00000001000000000000000000000000000000000000000000000000000000)
--- for sp
select * from  sys.dm_exec_procedure_stats
select * from  sys.dm_exec_procedure_stats order by total_worker_time desc
-----

WITH DB_CPU_Stats AS (SELECT DatabaseID, DB_Name(DatabaseID) AS [DatabaseName], 
   SUM(total_worker_time) AS [CPU_Time_Ms] 
    FROM sys.dm_exec_query_stats
    AS qs  CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID]   
    FROM sys.dm_exec_plan_attributes(qs.plan_handle)           
    WHERE attribute = N'dbid') AS F_DB  GROUP BY DatabaseID) 
    SELECT ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [row_num],  DatabaseName, [CPU_Time_Ms],  
    CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms])         OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUPercent]
     FROM DB_CPU_Stats WHERE DatabaseID > 4 -- system databases AND DatabaseID <> 32767
      -- ResourceDB ORDER BY row_num OPTION (RECOMPILE); 
-=======


top 5 Query

SELECT TOP 5  

    object_name(objectID)  

    ,[Avg CPU Time] = total_worker_time/execution_count  

    ,execution_count  

    ,Plan_handle  

    ,query_plan  

FROM sys.dm_exec_query_stats AS qs  

CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)  

ORDER BY total_worker_time/execution_count DESC; 


=============

db leverl

==

select plan_handle,
      sum(total_worker_time) as total_worker_time, 
      sum(execution_count) as total_execution_count,
      count(*) as  number_of_statements 
from sys.dm_exec_query_stats
group by plan_handle
order by sum(total_worker_time), sum(execution_count) desc

===

select * from sys.dm_exec_cached_plans --Shows the cached query plans. 
select * from sys.dm_exec_requests  --Shows each executing request in the SQL Server instance. 
select * from sys.dm_exec_sessions  --Shows all active user connections and internal tasks. 
select * from sys.dm_exec_sql_text  --Shows the text of the SQL batches. 
select * from sys.dm_os_tasks       --Shows each active task within SQL Server.


====
select * from sys.dm_exec_sessions

select * from sys.sysprocesses