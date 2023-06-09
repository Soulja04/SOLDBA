SELECT DB_NAME(dbid) as DBName FROM sys.sysdatabases;
             
                                    SELECT DB_NAME(dbid) as DBName, COUNT(dbid) as NConnections 
                                    from sys.sysprocesses as sp 
                                    inner join sys.dm_exec_connections as ex
                                    on sp.spid = ex.session_id
                                    WHERE dbid > 0
                                    GROUP BY dbid;



-- Get a count of SQL connections by IP address (Query 39) (Connection Counts by IP Address)
SELECT ec.client_net_address, es.[program_name], es.[host_name], es.login_name, 
COUNT(ec.session_id) AS [connection count] 
FROM sys.dm_exec_sessions AS es WITH (NOLOCK) 
INNER JOIN sys.dm_exec_connections AS ec WITH (NOLOCK) 
ON es.session_id = ec.session_id 
GROUP BY ec.client_net_address, es.[program_name], es.[host_name], es.login_name  
ORDER BY ec.client_net_address, es.[program_name] OPTION (RECOMPILE);
------

-- This helps you figure where your database load is coming from
-- and verifies connectivity from other machines