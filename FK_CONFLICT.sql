/****** Script for SelectTopNRows command from SSMS ******/
/** TRUNCATE and drop constraint**/


USE [Db4_ee]
GO

ALTER TABLE [dbo].[FH_RIDP_FIRST_REQUEST] DROP CONSTRAINT [FK_FH_RIDP_FIRST_REQUEST_PERSON_RIDP]
GO


SELECT * FROM T_PERSON_RIDP


TRUNCATE TABLE dbo.T_PERSON_RIDP



SELECT 
[PERSON_RIDP_ID] ---INTO #t1

FROM [Db4_ee].[dbo].[FH_RIDP_FIRST_REQUEST]


SELECT * FROM #t1


SET IDENTITY_INSERT t_person_ridp ON
INSERT INTO T_PERSON_RIDP (PERSON_RIDP_ID,ACCOUNT_id, person_id,ridp_status_id) SELECT DISTINCT PERSON_RIDP_ID,1,1,1 FROM #t1


SET IDENTITY_INSERT t_person_ridp OFF