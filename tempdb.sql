WITH TempResultsCTE
AS
(SELECT s.login_name, s.session_id, tsu.exec_context_id,
CASE WHEN tsu.user_objects_alloc_page_count > tsu.user_objects_dealloc_page_count
THEN (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)/128
ELSE 0
END AS user_objects_MB,
CASE WHEN tsu.internal_objects_alloc_page_count > tsu.internal_objects_dealloc_page_count
THEN (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count)/128
ELSE 0
END AS internal_objects_MB,
er.sql_handle,
er.plan_handle,
er.statement_start_offset,
er.statement_end_offset
FROM sys.dm_exec_requests er INNER JOIN sys.dm_exec_sessions s
ON er.session_id = s.session_id
INNER JOIN sys.dm_db_task_space_usage tsu ON er.session_id = tsu.session_id
WHERE s.is_user_process = 1)
SELECT login_name, session_id, exec_context_id,
user_objects_MB + internal_objects_MB as total_objects_MB,
user_objects_MB, internal_objects_MB,
CONVERT(XML, qp.query_plan) AS query_plan,
SUBSTRING(st.text, (tr.statement_start_offset/2)+1,
((CASE tr.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)
ELSE tr.statement_end_offset
END - tr.statement_start_offset)/2) + 1) AS statement_text,
st.text AS full_statement_text
FROM TempResultsCTE tr
CROSS APPLY sys.dm_exec_sql_text(tr.sql_handle) st
CROSS APPLY sys.dm_exec_text_query_plan(tr.plan_handle, tr.statement_start_offset, tr.statement_end_offset) qp
WHERE tr.user_objects_MB + tr.internal_objects_MB > 0
ORDER BY tr.user_objects_MB + tr.internal_objects_MB DESC;
WITH IdleTempResultsCTE
AS
(SELECT s.login_name, s.session_id,
CASE WHEN ssu.user_objects_alloc_page_count > ssu.user_objects_dealloc_page_count
THEN (ssu.user_objects_alloc_page_count - ssu.user_objects_dealloc_page_count)/128
ELSE 0
END AS user_objects_MB,
CASE WHEN ssu.internal_objects_alloc_page_count > ssu.internal_objects_dealloc_page_count
THEN (ssu.internal_objects_alloc_page_count - ssu.internal_objects_dealloc_page_count)/128
ELSE 0
END AS internal_objects_MB,
er.sql_handle,
er.plan_handle,
er.statement_start_offset,
er.statement_end_offset
FROM sys.dm_exec_requests er INNER JOIN sys.dm_exec_sessions s ON er.session_id = s.session_id
INNER JOIN sys.dm_db_session_space_usage ssu ON er.session_id = ssu.session_id
WHERE s.is_user_process = 1 AND s.status = 'sleeping')
SELECT login_name, session_id,
user_objects_MB + internal_objects_MB as total_objects_MB,
user_objects_MB, internal_objects_MB,
CONVERT(XML, qp.query_plan) AS query_plan,
SUBSTRING(st.text, (tr.statement_start_offset/2)+1,
((CASE tr.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)
ELSE tr.statement_end_offset
END - tr.statement_start_offset)/2) + 1) AS statement_text,
st.text AS full_statement_text
FROM IdleTempResultsCTE tr
CROSS APPLY sys.dm_exec_sql_text(tr.sql_handle) st
CROSS APPLY sys.dm_exec_text_query_plan(tr.plan_handle, tr.statement_start_offset, tr.statement_end_offset) qp
WHERE tr.user_objects_MB + tr.internal_objects_MB > 0
ORDER BY tr.user_objects_MB + tr.internal_objects_MB DESC