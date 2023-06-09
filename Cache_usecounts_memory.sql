
---- this will give you the percentage of the adhoc cached plan out of the whole cached plan
SELECT
T.AdHoc_Plan_MB, T.Total_Cache_MB,
t.AdHoc_Plan_MB*100.0 / t.Total_Cache_MB AS 'AdHoc %'
FROM (
SELECT SUM(CASE
WHEN objtype = 'adhoc'
           THEN CONVERT(BIGINT,size_in_bytes)
ELSE 0 END) / 1048576.0 AdHoc_Plan_MB,
           SUM(CONVERT(BIGINT,size_in_bytes)) / 1048576.0 Total_Cache_MB
FROM sys.dm_exec_cached_plans) T


------------ this will give you number of adhoc cached plans
SELECT SUM(c.usecounts)
, c.objtype
FROM sys.dm_exec_cached_plans AS c
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS q
GROUP BY c.objtype


-------this will give you number of times the plan been used big number is good with the script and the plan handel
SELECT    cplan.usecounts
                , cplan.objtype
                , qtext.text
                , qplan.query_plan
FROM sys.dm_exec_cached_plans AS cplan
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS qtext
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qplan
ORDER BY cplan.usecounts DESC


--------
SELECT c.usecounts
, c.objtype
, t.text
, q.query_plan
FROM sys.dm_exec_cached_plans AS c
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS q
WHERE t.text LIKE '%select% *%' AND q.dbid = 8 ----change select to desiered query txt
ORDER BY c.usecounts DESC


-------
DBCC FREEPROCCACHE