 
EXEC dbo.sp_BlitzIndex @DatabaseName='db4_ee', @SchemaName='dbo', @TableName='APPLICATION_INCOME_DETAIL';

EXEC dbo.sp_BlitzIndex @DatabaseName='staging', @SchemaName='dbo', @TableName='SDX_DATA_TEMPORAL_STAGING';

EXEC dbo.sp_blitzindex  @DatabaseName='staging'

EXEC dbo.sp_blitzindex @mode = 4

EXEC sp_Blitz @CheckServerInfo = 1, @OutputType = 'markdown'

EXEC dbo.sp_Blitz @CheckServerInfo = 1

EXEC dbo.sp_blitzcache @sortorder = 'CPU', @top = 10

EXEC dbo.sp_blitzcache @sortorder = 'read', @top = 10

EXEC dbo.sp_BlitzCache @SortOrder = 'duration', @top = 10

EXEC sp_BlitzCache @SortOrder = 'memory grant';

EXEC sp_BlitzCache @SortOrder = 'query HASH'

EXEC sp_BlitzCache @ExpertMode = 1

EXEC sp_BlitzFirst @ExpertMode = 1,  @Seconds=10

EXEC sp_AskBrent @Seconds=10, @ExpertMode=0



EXEC dbo.sp_blitzcache @StoredProcName = 'usp_SDX_Search'














