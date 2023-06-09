SELECT TOP 10 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads, qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes,
qs.total_worker_time,
qs.last_worker_time,
qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
qs.last_execution_time,
qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
---ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
 ORDER BY qs.total_worker_time DESC -- CPU time



 -------

 --1. expensive queries
    --text *and* statement
    --usage: modify WHERE & ORDER BY clauses to suit circumstances
SELECT TOP 25
      DB_Name(qp.dbid) as dbname , qp.dbid , qp.objectid , qp.number 
    --, qp.query_plan --the query plan can be *very* useful; enable if desired
    , qt.text 
    , SUBSTRING(qt.text, (qs.statement_start_offset/2) + 1,
        ((CASE statement_end_offset 
            WHEN -1 THEN DATALENGTH(qt.text)
            ELSE qs.statement_end_offset END 
                - qs.statement_start_offset)/2) + 1) as statement_text
    , qs.creation_time , qs.last_execution_time , qs.execution_count 
    , qs.total_worker_time    / qs.execution_count as avg_worker_time
    , qs.total_physical_reads / qs.execution_count as avg_physical_reads 
    , qs.total_logical_reads  / qs.execution_count as avg_logical_reads 
    , qs.total_logical_writes / qs.execution_count as avg_logical_writes 
    , qs.total_elapsed_time   / qs.execution_count as avg_elapsed_time 
    , qs.total_clr_time       / qs.execution_count as avg_clr_time
    , qs.total_worker_time , qs.last_worker_time , qs.min_worker_time , qs.max_worker_time 
    , qs.total_physical_reads , qs.last_physical_reads , qs.min_physical_reads , qs.max_physical_reads 
    , qs.total_logical_reads , qs.last_logical_reads , qs.min_logical_reads , qs.max_logical_reads 
    , qs.total_logical_writes , qs.last_logical_writes , qs.min_logical_writes , qs.max_logical_writes 
    , qs.total_elapsed_time , qs.last_elapsed_time , qs.min_elapsed_time , qs.max_elapsed_time
    , qs.total_clr_time , qs.last_clr_time , qs.min_clr_time , qs.max_clr_time 
    --, qs.sql_handle , qs.statement_start_offset , qs.statement_end_offset 
    , qs.plan_generation_num  -- , qp.encrypted 
    FROM sys.dm_exec_query_stats as qs 
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) as qp
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
    WHERE qs.execution_count > 10
		and qp.dbid = DB_ID()
    --ORDER BY qs.execution_count      DESC  --Frequency
    --ORDER BY qs.total_worker_time    DESC  --CPU
    --ORDER BY qs.total_elapsed_time   DESC  --Durn
    --ORDER BY qs.total_logical_reads  DESC  --Reads 
    --ORDER BY qs.total_logical_writes DESC  --Writes
    --ORDER BY qs.total_physical_reads DESC  --PhysicalReads    
    --ORDER BY avg_worker_time         DESC  --AvgCPU
    --ORDER BY avg_elapsed_time        DESC  --AvgDurn     
    ORDER BY avg_logical_reads       DESC  --AvgReads
    --ORDER BY avg_logical_writes      DESC  --AvgWrites
    --ORDER BY avg_physical_reads      DESC  --AvgPhysicalReads

    --sample WHERE clauses
    --WHERE last_execution_time > '20070507 15:00'
    --WHERE execution_count = 1
    --  WHERE SUBSTRING(qt.text, (qs.statement_start_offset/2) + 1,
    --    ((CASE statement_end_offset 
    --        WHEN -1 THEN DATALENGTH(qt.text)
    --        ELSE qs.statement_end_offset END 
    --            - qs.statement_start_offset)/2) + 1)
    --      LIKE '%MyText%'

 