
/*----Name: LoginWindowsGroupMemberSelect.sqlPurpose: To find all user accounts for a Windows Group in SQL Server logins.Author: Patrick SlesickiNotes:Returns all user logins for a Windows GroupSimply execute on an instance to get results.Tested on SQL Server versions 2012 through 2017. This should work on 2008 and 2008R2 but I've not tested it there.Adapted from a presentation by Laura Grob.Historyyyyy-mm-dd Init Description2018-02-14 PLS Created-------------------Preliminaries--------------*/
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;/*--------Declarations------------*/

DECLARE @WindowsGroupName AS NVARCHAR(128);
DECLARE @GroupLoginTable AS TABLE (AccountName NVARCHAR(128) NULL);
DECLARE @GroupLoginMemberTable AS TABLE (
	AccountName NVARCHAR(128) NULL
	,Type CHAR(8) NULL
	,Privilege CHAR(9) NULL
	,MappedLoginName NVARCHAR(128) NULL
	,PermissionPath NVARCHAR(128) NULL
	);/*----------------------------------Find windows groups------------------------*/

INSERT INTO @GroupLoginTable (AccountName)
SELECT name FROM sys.server_principals WHERE type_desc = N'WINDOWS_GROUP';/*------------Cycle through groups to find members------------------------------------*/

WHILE EXISTS (
		SELECT *
		FROM @GroupLoginTable
		) BEGIN SET @WindowsGroupName = (
		SELECT TOP (1) AccountName
		FROM @GroupLoginTable
		);
	INSERT INTO @GroupLoginMemberTable (
		AccountName
		,Type
		,Privilege
		,MappedLoginName
		,PermissionPath
		)
	EXEC sys.xp_logininfo @acctname = @WindowsGroupName
		,@option = 'members';

DELETE
FROM @GroupLoginTable WHERE AccountName = @WindowsGroupName;END;/*-----------------Output results-------------------*/

SELECT WindowsGroup = PermissionPath
	,AccountName
	,Privilege FROM @GroupLoginMemberTable ORDER BY WindowsGroup
	,AccountName;
	
	/*-------------------------END------------------------------*/