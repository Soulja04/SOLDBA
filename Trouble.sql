
--KILL 59 WITH STATUSONLY 

select loginame, cpu, memusage, physical_io, * 
  from  master..sysprocesses a
 where  exists ( select b.*
    from master..sysprocesses b
    where b.blocked > 0 and
   b.blocked = a.spid ) and not
 exists ( select b.*
     from master..sysprocesses b
    where b.blocked > 0 and
   b.spid = a.spid ) 
order by spid

-----
EXEC sp_who2 ACTIVE --106 116 265 271 130, 241 284 295 291 243 292 141 262 301 304

EXEC DBCC INPUTBUFFER ()

EXEC sp_whoisactive 

EXEC DBA.dbo.sp_BlitzFirst @ExpertMode = 1  

select * from master.dbo.sysprocesses WHERE blocked > 1

---=-=-
select * from sys.sysprocesses where  spid >= 50 and blocked <> 0


EXEC sys.xp_readerrorlog 0, 1, N'detected', N'socket';


SELECT * FROM sys.dm_exec_query_memory_grants where grant_time is null 


 