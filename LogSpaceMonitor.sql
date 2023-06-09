USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[USP_LogSpaceMonitor]    Script Date: 2/10/2021 2:11:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROC [dbo].[USP_LogSpaceMonitor] 
AS 
BEGIN 
 
IF(object_id('DBA.dbo.Logspace') is NULL)   
Begin   
  Create table Logspace   
  (DBName varchar(200),   
  OldSize Numeric(20,2),   
  CurSize Numeric(20,2),   
  UsedSize Numeric(20,2),   
  GrowthTime datetime,   
  [status] int) 
   
  Insert into Logspace (DBName, CurSize, UsedSize, [Status])   
                  Exec('DBCC SQLPERF (Logspace)')    
  UPDATE Logspace   
  SET GrowthTime = GETDATE()   
END 
 
 
Declare @logSpace As Table   
      (DBName Varchar(200),          
      logSize Numeric(20,2),       
      UsedSpace Numeric(20,2),   
      [status] int)         
   
Declare @Heading varchar(100),@head varchar(100),@tableHtml varchar(max)   
   
Insert Into @LogSpace (DBName, LogSize, UsedSpace, [Status])   
                Exec('DBCC SQLPERF (Logspace)')    
 
---Copy Current size to Old Size   
update LogSpace   
set OldSize = CurSize   
   
--Update Growth Time   
Update Logspace   
set GrowthTime = getdate()   
from Logspace L   
join @LogSpace T    
on L.DBname = T.DBName   
where L.cursize <> T.LogSize   
   
   
--Copy new data to table   
Update Logspace   
set UsedSize = T.UsedSpace , CurSize = T.LogSize   
from Logspace L   
join @LogSpace T    
on L.DBname = T.DBName   
 
 
IF EXISTS(SELECT * FROM @LogSpace WHERE UsedSpace >= 60 )   
 BEGIN   
                SET @Heading = 'Log Space details for SERVER : '+@@servername     
                SET @tableHTML = N'<HTML><HEAD><TITLE>Fragmentation</TITLE><BODY>' +                                                             
                                '<TABLE border="1" style="font-family:verdana; font-size:12;">   
                                <TR><TH COLSPAN="7" bgColor="Blue" style="font-family:verdana; font-size:15; font-weight:bold; text-align:left"><H>'+ @Heading + '</H></TH></TR>   
      <TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>DB Name</STRONG></FONT></TH>   
   <TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>Old Size (MB)</STRONG></FONT></TH>   
   <TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>Current Log Size (MB)</STRONG></FONT></TH>   
      <TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>Used Space (%)</STRONG></FONT></TH>   
   <TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>File Size changed</STRONG></FONT></TH>   
<TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>Recovery Model</STRONG></FONT></TH> 
      <TH bgColor="#CCCCCC"><FONT color="#ffffff"><STRONG>Reason : Log not getting Reused</STRONG></FONT></TH></TR>'+   
   CAST ( (SELECT      
                         td = DBName, ''   
                        ,td =  oldsize, ''   
                        ,td =  cursize, ''   
                        ,td =  usedspace, ''   
                        ,td =  GrowthTime, ''   
                        ,td =  recovery_model_desc, ''  
                        ,td =  log_reuse_wait_desc , ''   
                        FROM (SELECT (CASE WHEN L.oldsize<> L.Cursize   
    THEN L.dbname+'***'   
   ELSE   
    L.dbname   
   END )DBName ,L.Oldsize,CONVERT(VARCHAR(10),L.Cursize) AS 'Cursize',   
      CONVERT(VARCHAR(10),L.UsedSize) AS 'usedspace',CONVERT(VARCHAR(20),L.GrowthTime) AS 'GrowthTime', 
      D.recovery_model_desc, D.log_reuse_wait_desc  FROM LogSpace L   
      JOIN sys.databases D ON L.dbname = D.name AND L.UsedSize >= 70)t   
                  FOR XML PATH('tr'), TYPE    
            ) AS NVARCHAR(MAX) ) +   
  N'</TABLE><BR><BR><B> <I> Note: <DBName>*** indicates that file size has been changed !</BODY></HTML>';    
--print    
 PRINT @tableHTML    
   
--############################Send Mail#############################   
   
 SET @head = 'Log Space report '+@@servername+' > 60%'   
   
 EXEC msdb.dbo.sp_send_dbmail       
 @profile_name = 'DBMailProfile', 
 @recipients = 'sahaja.madineni@cares.alabama.gov',      
 @subject = @head,   
 @body = @tableHTML,       
 @body_format = 'HTML'    
   
END 
END 
 
GO


