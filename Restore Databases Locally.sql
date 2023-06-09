/*
	This script is provided AS-IS. Use at your own risk.

	If you get the following error:
	Logical file {FILE_NAME} is not part of database {DATABASE_NAME}. Use RESTORE FILELISTONLY to list the logical file names.

	Use the following command to get the file names:
	RESTORE FILELISTONLY FROM  DISK = @BackupFullPath
*/

/*==========================================================================================================================================================*/

/*	Restores staging	*/
USE [master]

/*	Backup Information	*/
DECLARE	@BackupFileName NVARCHAR(100),
		/*	Set this to the folder path where the backup file is located. Include the trailing '\'
			This path can be a local path (C:\Temp\Backups\), if the file was copied locally or a network path (\\msvdidcsql01\CARESBU\Cares)
		*/
		@BackupPathName	NVARCHAR(100) = 'C:\DELL\{BackupFileName}.bak',
		@BackupFullPath	NVARCHAR(200);

SET	@BackupFileName = 'staging_mac4';	--	Get the latest backup name from the shared drive. \\msvdidcsql01\CARESBU\Cares
SET	@BackupFullPath = REPLACE(@BackupPathName , '{BackupFileName}', @BackupFileName);

/*	Local Instance Information	*/
DECLARE	@InstanceName		NVARCHAR(40),	-- This is the name of the local instance of SQL Server installed on the machine.
		@DatabaseName		NVARCHAR(40),
		@LocalFolderPath	NVARCHAR(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.{InstanceName}\MSSQL\DATA\{DatabaseName}.{Extension}',
		@DatabaseExtension	NCHAR(3) = 'mdf',
		@IndexExtension		NCHAR(3) = 'ndf',
		@LogExtension		NCHAR(3) = 'ldf',
		@DatabasePath		NVARCHAR(400),
		@IndexPath			NVARCHAR(400),
		@LogPath			NVARCHAR(400);

SET @InstanceName = 'CARESOL';
SET	@DatabaseName = 'staging';
SET @DatabasePath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @DatabaseExtension);
SET @IndexPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @IndexExtension);
SET @LogPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @LogExtension);

IF (CHARINDEX('MS-', @@SERVERNAME) = 1)	--	Only execute on the local machine.
BEGIN
	/*	This closes any existing connections that may be open to the database that is being restored.	*/
	IF (EXISTS (SELECT name FROM master.sys.databases WHERE name = @DatabaseName))
	BEGIN
		EXECUTE('ALTER DATABASE [' + @DatabaseName + '] SET OFFLINE WITH ROLLBACK IMMEDIATE');
		PRINT	@DatabaseName + ' is offline!';
	END

	SELECT @BackupFullPath, @DatabasePath, @IndexPath, @LogPath;

	RESTORE DATABASE [staging] FROM  DISK = @BackupFullPath
	WITH  FILE = 1,  
	MOVE N'staging_Main' TO @DatabasePath,  
	MOVE N'staging_Indexes' TO @IndexPath,  
	MOVE N'staging_Main_log' TO @LogPath,  NOUNLOAD,  REPLACE,  STATS = 5
END
ELSE
BEGIN
	DECLARE @ErrorMessage VARCHAR(40) = 'Trying to execute on server: ' + @@SERVERNAME;
	THROW 60000, @ErrorMessage, 1;
END

GO


/*==========================================================================================================================================================*/


/*	Restores db4_ee	*/
USE [master]

/*	Backup Information	*/
DECLARE	@BackupFileName NVARCHAR(100),
		/*	Set this to the folder path where the backup file is located. Include the trailing '\'
			This path can be a local path (C:\Temp\Backups\), if the file was copied locally or a network path (\\msvdidcsql01\CARESBU\Cares)
		*/
		@BackupPathName	NVARCHAR(100) = '\\Adidcsql1\e$\Shared_backups\{BackupFileName}.bak',	
		@BackupFullPath	NVARCHAR(200);

SET	@BackupFileName = 'mac4_db4_ee';	--	Get the latest backup name from the shared drive. \\msvdidcsql01\CARESBU\Cares
SET	@BackupFullPath = REPLACE(@BackupPathName , '{BackupFileName}', @BackupFileName);

/*	Local Instance Information	*/
DECLARE	@InstanceName		NVARCHAR(40),	-- This is the name of the local instance of SQL Server installed on the machine.
		@DatabaseName		NVARCHAR(40),
		@LocalFolderPath	NVARCHAR(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.{InstanceName}\MSSQL\DATA\{DatabaseName}.{Extension}',
		@DatabaseExtension	NCHAR(3) = 'mdf',
		@IndexExtension		NCHAR(3) = 'ndf',
		@LogExtension		NCHAR(3) = 'ldf',
		@DatabasePath		NVARCHAR(400),
		@IndexPath			NVARCHAR(400),
		@LogPath			NVARCHAR(400),
		@RuleXML			NVARCHAR(400);

SET @InstanceName = 'CARESDBA';
SET	@DatabaseName = 'db4_ee';
SET @DatabasePath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @DatabaseExtension);
SET @IndexPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @IndexExtension);
SET @LogPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @LogExtension);
SET @RuleXML = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', 'db4_ee_rulepayload'), '{Extension}', @IndexExtension);

IF (CHARINDEX('MS-', @@SERVERNAME) = 1)	--	Only execute on the local machine.
BEGIN
	/*	This closes any existing connections that may be open to the database that is being restored.	*/
	IF (EXISTS (SELECT name FROM master.sys.databases WHERE name = @DatabaseName))
	BEGIN
		EXECUTE('ALTER DATABASE [' + @DatabaseName + '] SET OFFLINE WITH ROLLBACK IMMEDIATE');
		PRINT	@DatabaseName + ' is offline!';
	END

	SELECT @BackupFullPath, @DatabasePath, @IndexPath, @LogPath;

	RESTORE DATABASE [db4_ee] FROM  DISK = @BackupFullPath
	WITH  FILE = 1,  
	MOVE N'db4_ee_Main' TO @DatabasePath,  
	MOVE N'Indexes' TO @IndexPath,  
	MOVE N'db4_ee_Main_log' TO @LogPath,
	MOVE N'db4_ee_Rulepayloadxml_2' TO @RuleXML,  NOUNLOAD,  REPLACE,  STATS = 5
END
ELSE
BEGIN
	DECLARE @ErrorMessage VARCHAR(40) = 'Trying to execute on server: ' + @@SERVERNAME;
	THROW 60000, @ErrorMessage, 1;
END

GO


/*==========================================================================================================================================================*/

/*	Restores Visual Guard	*/
USE [master]

/*	Backup Information	*/
DECLARE	@BackupFileName NVARCHAR(100),
		/*	Set this to the folder path where the backup file is located. Include the trailing '\'
			This path can be a local path (C:\Temp\Backups\), if the file was copied locally or a network path (\\msvdidcsql01\CARESBU\Cares)
		*/
		@BackupPathName	NVARCHAR(100) = '\\Adidcsql1\e$\Shared_backups\{BackupFileName}.bak',	
		@BackupFullPath	NVARCHAR(200);

SET	@BackupFileName = 'VG';	--	Get the latest backup name from the shared drive. \\msvdidcsql01\CARESBU\Cares
SET	@BackupFullPath = REPLACE(@BackupPathName , '{BackupFileName}', @BackupFileName);

/*	Local Instance Information	*/
DECLARE	@InstanceName		NVARCHAR(40),	-- This is the name of the local instance of SQL Server installed on the machine.
		@DatabaseName		NVARCHAR(40),
		@LocalFolderPath	NVARCHAR(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.{InstanceName}\MSSQL\DATA\{DatabaseName}.{Extension}',
		@DatabaseExtension	NCHAR(3) = 'mdf',
		@IndexExtension		NCHAR(3) = 'ndf',
		@LogExtension		NCHAR(3) = 'ldf',
		@DatabasePath		NVARCHAR(400),
		@IndexPath			NVARCHAR(400),
		@LogPath			NVARCHAR(400);

SET @InstanceName = 'DEV';
SET	@DatabaseName = 'VisualGuard';
SET @DatabasePath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @DatabaseExtension);
SET @IndexPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @IndexExtension);
SET @LogPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @LogExtension);

IF (CHARINDEX('MS-LT', @@SERVERNAME) = 1)	--	Only execute on the local machine.
BEGIN
	/*	This closes any existing connections that may be open to the database that is being restored.	*/
	IF (EXISTS (SELECT name FROM master.sys.databases WHERE name = @DatabaseName))
	BEGIN
		EXECUTE('ALTER DATABASE [' + @DatabaseName + '] SET OFFLINE WITH ROLLBACK IMMEDIATE');
		PRINT	@DatabaseName + ' is offline!';
	END

	SELECT @BackupFullPath, @DatabasePath, @IndexPath, @LogPath;

	RESTORE DATABASE [VisualGuard] FROM  DISK = @BackupFullPath
	WITH  FILE = 1,  
	MOVE N'vg' TO @DatabasePath,  
	--MOVE N'Indexes' TO @IndexPath,  --	No indexes for this database at this time.
	MOVE N'vg_log' TO @LogPath,  NOUNLOAD,  REPLACE,  STATS = 5
END
ELSE
BEGIN
	DECLARE @ErrorMessage VARCHAR(40) = 'Trying to execute on server: ' + @@SERVERNAME;
	THROW 60000, @ErrorMessage, 1;
END

GO


--/*==========================================================================================================================================================*/

/*	Restores Log	*/
USE [master]

/*	Backup Information	*/
DECLARE	@BackupFileName NVARCHAR(100),
		/*	Set this to the folder path where the backup file is located. Include the trailing '\'
			This path can be a local path (C:\Temp\Backups\), if the file was copied locally or a network path (\\msvdidcsql01\CARESBU\Cares)
		*/
		@BackupPathName	NVARCHAR(100) = '\\msvdidcsql01\CARESBU\Cares\{BackupFileName}.bak',	
		@BackupFullPath	NVARCHAR(200);

SET	@BackupFileName = 'log_2019-03-05-112543';	--	Get the latest backup name from the shared drive. \\msvdidcsql01\CARESBU\Cares
SET	@BackupFullPath = REPLACE(@BackupPathName , '{BackupFileName}', @BackupFileName);

/*	Local Instance Information	*/
DECLARE	@InstanceName		NVARCHAR(40),	-- This is the name of the local instance of SQL Server installed on the machine.
		@DatabaseName		NVARCHAR(40),
		@LocalFolderPath	NVARCHAR(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.{InstanceName}\MSSQL\DATA\{DatabaseName}.{Extension}',
		@DatabaseExtension	NCHAR(3) = 'mdf',
		@IndexExtension		NCHAR(3) = 'ndf',
		@LogExtension		NCHAR(3) = 'ldf',
		@DatabasePath		NVARCHAR(400),
		@IndexPath			NVARCHAR(400),
		@LogPath			NVARCHAR(400);

SET @InstanceName = 'DEV';
SET	@DatabaseName = 'Log';
SET @DatabasePath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @DatabaseExtension);
SET @IndexPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @IndexExtension);
SET @LogPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @LogExtension);

IF (CHARINDEX('MS-LT', @@SERVERNAME) = 1)	--	Only execute on the local machine.
BEGIN
	/*	This closes any existing connections that may be open to the database that is being restored.	*/
	IF (EXISTS (SELECT name FROM master.sys.databases WHERE name = @DatabaseName))
	BEGIN
		EXECUTE('ALTER DATABASE [' + @DatabaseName + '] SET OFFLINE WITH ROLLBACK IMMEDIATE');
		PRINT	@DatabaseName + ' is offline!';
	END

	SELECT @BackupFullPath, @DatabasePath, @IndexPath, @LogPath;

	RESTORE DATABASE [Log] FROM  DISK = @BackupFullPath
	WITH  FILE = 1,  
	MOVE N'Log_test' TO @DatabasePath,  
	--MOVE N'Indexes' TO @IndexPath,  --	No indexes for this database at this time.
	MOVE N'Log_test_log' TO @LogPath,  NOUNLOAD,  REPLACE,  STATS = 5
END
ELSE
BEGIN
	DECLARE @ErrorMessage VARCHAR(40) = 'Trying to execute on server: ' + @@SERVERNAME;
	THROW 60000, @ErrorMessage, 1;
END

GO

--/*==========================================================================================================================================================*/


--SELECT * FROM CHIP.sys.database_files


/*	Restores CHIP	*/
USE [master]

/*	Backup Information	*/
DECLARE	@BackupFileName NVARCHAR(100),
		/*	Set this to the folder path where the backup file is located. Include the trailing '\'
			This path can be a local path (C:\Temp\Backups\), if the file was copied locally or a network path (\\msvdidcsql01\CARESBU\Cares)
		*/
		@BackupPathName	NVARCHAR(100) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.CARESDBA\MSSQL\Backup\{BackupFileName}.bak',	
		@BackupFullPath	NVARCHAR(200);

SET	@BackupFileName = 'CHIP';	--	do not Include the BAK file extension
SET	@BackupFullPath = REPLACE(@BackupPathName , '{BackupFileName}', @BackupFileName);

/*	Local Instance Information	*/
DECLARE	@InstanceName		NVARCHAR(40),	-- This is the name of the local instance of SQL Server installed on the machine.
		@DatabaseName		NVARCHAR(40),
		@LocalFolderPath	NVARCHAR(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.{InstanceName}\MSSQL\DATA\{DatabaseName}.{Extension}',
		@DatabaseExtension	NCHAR(3) = 'mdf',	
		@LogExtension		NCHAR(3) = 'ldf',
		@DatabasePath		NVARCHAR(400),
		@IndexPath			NVARCHAR(400),
		@LogPath			NVARCHAR(400);

SET @InstanceName = 'CARESDBA';
SET	@DatabaseName = 'CHIP';
SET @DatabasePath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @DatabaseExtension);
---SET @IndexPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @IndexExtension);
SET @LogPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '{InstanceName}', @InstanceName), '{DatabaseName}', @DatabaseName), '{Extension}', @LogExtension);

/*	This closes any existing connections that may be open to the database that is being restored.	*/
IF (EXISTS (SELECT name FROM master.sys.databases WHERE name = @DatabaseName))
BEGIN
	EXECUTE('ALTER DATABASE [' + @DatabaseName + '] SET OFFLINE WITH ROLLBACK IMMEDIATE');
	PRINT	@DatabaseName + ' is offline!';
END

SELECT @BackupFullPath, @DatabasePath, @IndexPath, @LogPath;

RESTORE DATABASE [CHIP] FROM  DISK = @BackupFullPath
WITH  FILE = 1,  
MOVE N'CHIP' TO @DatabasePath,  
MOVE N'CHIP_log' TO @LogPath,  NOUNLOAD,  REPLACE,  STATS = 5

GO