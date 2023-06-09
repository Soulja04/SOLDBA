SET SHOWPLAN_ALL ON
GO

-- FMTONLY will not exec stored proc
SET FMTONLY ON
GO

exec [dbo].[usp_ExtendMedicaidEnrollments_dueto_COVID_19]
GO

SET FMTONLY OFF
GO

SET SHOWPLAN_ALL OFF
GO


SET STATISTICS IO, TIME	on
---XML
SET SHOWPLAN_XML ON
GO

-- FMTONLY will not exec stored proc
SET FMTONLY ON
GO


EXEC  [dbo].[usp_INS_In_FHServices]  @applicationId = 5288441, @atTransferHeaderId = 1824547,  @thActivityIdenId = 'FFM50459450327194031', @updatedBy = 'ATADMIN'
GO

SET FMTONLY OFF
GO

SET SHOWPLAN_XML OFF
GO


SET STATISTICS IO, TIME	OFF