
-- when did it last run

select
 db_name() [database name]
,[schema name] = SCHEMA_NAME([schema_id])
,o.name
,ps.last_execution_time 
from   sys.dm_exec_procedure_stats ps 
inner join
       sys.objects o 
       ON ps.object_id = o.object_id 
where o.type = 'P'
--and o.schema_id = schema_name(schema_id)
and o.name = 'usp_INS_In_Person'
order by
       ps.last_execution_time desc



-- display create datetime and last modified datetime
select 
 [database name] = db_name() 
,[schema name] =  SCHEMA_NAME([schema_id])
,name [stored proc name]
,create_date [create date]
,modify_date [last modify date]
from sys.objects
where type = 'P'
and name = 'usp_INS_In_Person'


-------------
SELECT  
        SCHEMA_NAME(sysobject.schema_id),
        OBJECT_NAME(stats.object_id), 
        stats.last_execution_time
    FROM   
        sys.dm_exec_procedure_stats stats
        INNER JOIN sys.objects sysobject ON sysobject.object_id = stats.object_id 
    WHERE  
        sysobject.type = 'P'
    ORDER BY
           stats.last_execution_time DESC  


---------------------
		   SELECT  
    SCHEMA_NAME(sysobject.schema_id),
    OBJECT_NAME(stats.object_id), 
    stats.last_execution_time
FROM   
    sys.dm_exec_procedure_stats stats
    INNER JOIN sys.objects sysobject ON sysobject.object_id = stats.object_id 
WHERE  
    sysobject.type = 'P'
    and (sysobject.object_id = object_id('dbo.usp_RRV_CLEANUP') 
    OR sysobject.name = 'usp_RRV_CLEANUP')
ORDER BY
       stats.last_execution_time DESC  


