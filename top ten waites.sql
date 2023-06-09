

select top 10 *
from sys.dm_os_wait_stats
where wait_type not in --remove common waits to identify worst bottlenecks
( 
'KSOURCE_WAKEUP', 'SLEEP_BPOOL_FLUSH', 'BROKER_TASK_STOP',
'XE_TIMER_EVENT', 'XE_DISPATCHER_WAIT', 'FT_IFTS_SCHEDULER_IDLE_WAIT',   
'SQLTRACE_BUFFER_FLUSH', 'CLR_AUTO_EVENT', 'BROKER_EVENTHANDLER',
'LAZYWRITER_SLEEP', 'BAD_PAGE_PROCESS', 'BROKER_TRANSMITTER', 
'CHECKPOINT_QUEUE', 'DBMIRROR_EVENTS_QUEUE', 'LAZYWRITER_SLEEP', 
'ONDEMAND_TASK_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'LOGMGR_QUEUE', 
'SLEEP_TASK', 'SQLTRACE_BUFFER_FLUSH', 'CLR_MANUAL_EVENT',
'BROKER_RECEIVE_WAITFOR', 'PREEMPTIVE_OS_GETPROCADDRESS', 
'PREEMPTIVE_OS_AUTHENTICATIONOPS', 'BROKER_TO_FLUSH'
) 
order by wait_time_ms desc



--If you have PAGEIOLATCH_*, ASYNC_IO_COMPLETION, IO_COMPLETION, or WRITELOG in your top waits, your system is consistently waiting on your disks and 
--you need to troubleshoot that.  Start by going through this document and its troubleshooting procedures:

--http://download.microsoft.com/download/6/e/5/6e52bf39-0519-42b7-b806-c32905f4a066/TechNote28-CommonQAfordeployingSQLServerinaSANenvironment.pdf

--Instant file intitialization isn't going to fix the underlying problem, it will just alleviate the additional IO demand during the initialization process.

