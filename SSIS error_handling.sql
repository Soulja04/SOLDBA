/* Below is a practice we used in SSIS package event handlers to send package 
specific errors email during runtime. We suggest all new SSIS packages to include this


"Hi All

The Package " +  @[System::PackageName] + ".dtsx have failed with below error

Task Name: " +  @[System::SourceName] +"

Error Code: " +  (DT_WSTR,50)@[System::ErrorCode] + "

Error Description: " +  @[System::ErrorDescription] + "

I am looking into this error. Please contact me if you have any questions

Thanks & Regards
DBA"

*/
BEGIN TRY
	BEGIN TRAN --Your codes GO here
	SELECT @@version
	COMMIT TRAN
END TRY

BEGIN CATCH
	DECLARE @ErrorLine INT;
	DECLARE @ErrorMessage VARCHAR(4000);
	DECLARE @ErrorNumber INT;
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	DECLARE @ErrorProcedure VARCHAR(4000);
	DECLARE @ErrorFinal VARCHAR(4000);

	SELECT @ErrorLine = ERROR_LINE()
		,@ErrorMessage = ERROR_MESSAGE()
		,@ErrorNumber = ERROR_NUMBER()
		,@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE()
		,@ErrorProcedure = ERROR_PROCEDURE()
		,@ErrorFinal = CONCAT (
			'ErrorLine - '
			,TRY_CONVERT(VARCHAR, @ErrorLine)
			,', ErrorMessage - '
			,@ErrorMessage
			,', ErrorNumber - '
			,TRY_CONVERT(VARCHAR, @ErrorNumber)
			,', ErrorSeverity - '
			,@ErrorSeverity
			,', ErrorState - '
			,@ErrorState
			,', ErrorProcedure - '
			,@ErrorProcedure
			)

	RAISERROR (
			@ErrorFinal
			,-- @ErrorMessage, --Message text. 
			@ErrorSeverity
			,-- Severity. 
			@ErrorState -- State. 
			);

	ROLLBACK TRAN
END CATCH

