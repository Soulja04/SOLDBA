USE db4_ee;
GO

DECLARE @Operation_Started nvarchar(max) = N'Operation started.',
	@Operation_Ended     nvarchar(max) = N'Operation ended.',
	@Transaction_Start_Msg     nvarchar(max) = N'Transaction started.',
	@Transaction_End_Msg nvarchar(max) = N'Transaction ended.',
	@Commit_Msg     nvarchar(max) = N'Transaction Committed successfully.',
	@RollBack_Msg nvarchar(max) = N'Transaction Unsuccessful. Rolled Back!. No Further DB Operation Needed! Inform the Developer.';

PRINT @Transaction_Start_Msg;
BEGIN TRANSACTION

BEGIN TRY
---------------------------------------------------------------------------------------------
-- BEGIN of All Operations
---------------------------------------------------------------------------------------------

	---------------------------------------
	-- BEGIN Operation 1
	---------------------------------------
	PRINT  @Operation_Started + ' No:1';
	---------------------------------------

/**

Place code here

**/

	---------------------------------------
	-- END Operation 1
	---------------------------------------
	PRINT  @Operation_Ended + ' No:1';
	---------------------------------------

---------------------------------------------------------------------------------------------
-- END of All Operations
---------------------------------------------------------------------------------------------

COMMIT TRANSACTION
PRINT @Commit_Msg;

PRINT @Transaction_End_Msg;

END TRY
BEGIN CATCH

ROLLBACK TRANSACTION
	PRINT @RollBack_Msg;

	SELECT @RollBack_Msg AS 'ERROR!'

	SELECT 
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage

END CATCH