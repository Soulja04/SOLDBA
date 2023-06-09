USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[TempDBSniffing]    Script Date: 8/12/2020 2:39:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Selamu Abebe
-- Create date: 02/19/2021
-- Description:	This is to sample tempdb usage to determine what is causing the huge spike in the file usage. 
-- =============================================
CREATE PROCEDURE [dbo].[TempDBSniffing]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT COALESCE(T1.session_id, T2.session_id) [session_id], -- T1.request_id ,
           COALESCE(T1.database_id, T2.database_id) [database_id],
           COALESCE(T1.[Total Allocation User Objects], 0) + T2.[Total Allocation User Objects] [Total Allocation User Objects MB],
           COALESCE(T1.[Net Allocation User Objects], 0) + T2.[Net Allocation User Objects] [Net Allocation User Objects MB],
           COALESCE(T1.[Total Allocation Internal Objects], 0) + T2.[Total Allocation Internal Objects] [Total Allocation Internal Objects MB],
           COALESCE(T1.[Net Allocation Internal Objects], 0) + T2.[Net Allocation Internal Objects] [Net Allocation Internal Objects MB],
           COALESCE(T1.[Total Allocation], 0) + T2.[Total Allocation] [Total Allocation MB],
           COALESCE(T1.[Net Allocation], 0) + T2.[Net Allocation] [Net Allocation MB],
           COALESCE(T1.[Query Text], T2.[Query Text]) [Query Text],
           GETDATE() timestamp
    INTO #tempdblog
    FROM
    (
        SELECT DISTINCT
               TS.session_id,
               TS.request_id,
               TS.database_id,
               CAST(TS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects],
               CAST((TS.user_objects_alloc_page_count - TS.user_objects_dealloc_page_count) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects],
               CAST(TS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects],
               CAST((TS.internal_objects_alloc_page_count - TS.internal_objects_dealloc_page_count) / 128 AS DECIMAL(15, 2)) [Net Allocation Internal Objects],
               CAST((TS.user_objects_alloc_page_count + internal_objects_alloc_page_count) / 128 AS DECIMAL(15, 2)) [Total Allocation],
               CAST((TS.user_objects_alloc_page_count + TS.internal_objects_alloc_page_count
                     - TS.internal_objects_dealloc_page_count - TS.user_objects_dealloc_page_count
                    ) / 128 AS DECIMAL(15, 2)) [Net Allocation],
               T.text [Query Text]
        FROM sys.dm_db_task_space_usage TS
            INNER JOIN sys.dm_exec_requests ER
                ON ER.request_id = TS.request_id
                   AND ER.session_id = TS.session_id
            OUTER APPLY sys.dm_exec_sql_text(ER.sql_handle) T
    ) T1
        RIGHT JOIN
        (
            SELECT SS.session_id,
                   SS.database_id,
                   CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects],
                   CAST((SS.user_objects_alloc_page_count - SS.user_objects_dealloc_page_count) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects],
                   CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects],
                   CAST((SS.internal_objects_alloc_page_count - SS.internal_objects_dealloc_page_count) / 128 AS DECIMAL(15, 2)) [Net Allocation Internal Objects],
                   CAST((SS.user_objects_alloc_page_count + internal_objects_alloc_page_count) / 128 AS DECIMAL(15, 2)) [Total Allocation],
                   CAST((SS.user_objects_alloc_page_count + SS.internal_objects_alloc_page_count
                         - SS.internal_objects_dealloc_page_count - SS.user_objects_dealloc_page_count
                        ) / 128 AS DECIMAL(15, 2)) [Net Allocation],
                   T.text [Query Text]
            FROM sys.dm_db_session_space_usage SS
                LEFT JOIN sys.dm_exec_connections CN
                    ON CN.session_id = SS.session_id
                OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T
        ) T2
            ON T1.session_id = T2.session_id
    WHERE (COALESCE(T1.[Total Allocation], 0) + T2.[Total Allocation]) > 100;


    CREATE TABLE #SPresults
    (
        SPID INT,
        status VARCHAR(100),
        login VARCHAR(100),
        hostname VARCHAR(100),
        blkBy VARCHAR(100),
        dbname VARCHAR(50),
        command VARCHAR(500),
        CPUTime BIGINT,
        diskIO BIGINT,
        lastbatch VARCHAR(100),
        programName VARCHAR(250),
        SPID2 INT,
        RequestID INT
    );


    INSERT INTO #SPresults
    EXEC sp_who2;
    --SELECT SPID, login, dbname, command, lastbatch, diskIO  FROM #SPresults where diskIO > 0 and SPID in  (select distinct session_id from #tempdblog )


INSERT INTO [dba].[dbo].[tempdbSampling]
           ([session_id]
           ,[database_id]
           ,[Total Allocation User Objects MB]
           ,[Net Allocation User Objects MB]
           ,[Total Allocation Internal Objects MB]
           ,[Net Allocation Internal Objects MB]
           ,[Total Allocation MB]
           ,[Net Allocation MB]
           ,[Query Text]
           ,[timestamp]
           ,[SPID]
           ,[status]
           ,[login]
           ,[hostname]
           ,[blkBy]
           ,[dbname]
           ,[command]
           ,[CPUTime]
           ,[diskIO]
           ,[lastbatch]
           ,[programName]
           ,[SPID2]
           ,[RequestID])
    SELECT a.*,
           b.* 
    FROM #tempdblog AS a
        INNER JOIN #SPresults b
            ON a.session_id = b.SPID;

    DROP TABLE #SPresults;
    DROP TABLE #tempdblog;
	

END;

GO


----USE [DBA]
----GO

----/****** Object:  Table [dbo].[tempdbSampling]    Script Date: 6/11/2021 1:20:09 PM ******/
----SET ANSI_NULLS ON
----GO

----SET QUOTED_IDENTIFIER ON
----GO

----CREATE TABLE [dbo].[tempdbSampling](
----	[session_id] [SMALLINT] NULL,
----	[database_id] [INT] NULL,
----	[Total Allocation User Objects MB] [DECIMAL](16, 2) NULL,
----	[Net Allocation User Objects MB] [DECIMAL](16, 2) NULL,
----	[Total Allocation Internal Objects MB] [DECIMAL](16, 2) NULL,
----	[Net Allocation Internal Objects MB] [DECIMAL](16, 2) NULL,
----	[Total Allocation MB] [DECIMAL](16, 2) NULL,
----	[Net Allocation MB] [DECIMAL](16, 2) NULL,
----	[Query Text] [NVARCHAR](MAX) NULL,
----	[timestamp] [DATETIME] NOT NULL,
----	[SPID] [INT] NULL,
----	[status] [VARCHAR](100) NULL,
----	[login] [VARCHAR](100) NULL,
----	[hostname] [VARCHAR](100) NULL,
----	[blkBy] [VARCHAR](100) NULL,
----	[dbname] [VARCHAR](50) NULL,
----	[command] [VARCHAR](500) NULL,
----	[CPUTime] [BIGINT] NULL,
----	[diskIO] [BIGINT] NULL,
----	[lastbatch] [VARCHAR](100) NULL,
----	[programName] [VARCHAR](250) NULL,
----	[SPID2] [INT] NULL,
----	[RequestID] [INT] NULL
----) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
----GO
