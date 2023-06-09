/*==========================================================================================================================================================*/
SET NOCOUNT ON;
GO

----:SETVAR BackupFullPath			*******!!!!!!!!!!!!!!!!
----:SETVAR BackupFileName			SSSS
----:SETVAR InstanceName			MSSQLServer
----:SETVAR DatabaseName			db4_ee
----:SETVAR Extension				BAK

/* Prevent accidentally running on production */
IF @@SERVERNAME = N'MSVPIDCSQL01\CARES' 
BEGIN
	PRINT 'Wrong server';
 	RETURN
END 

print ('$(DatabaseName)')

--IF DB_ID('$(DatabaseName)') IS NULL 
--BEGIN
--	CREATE DATABASE $(DatabaseName),
--END
--/*==========================================================================================================================================================*/
--/*	Restores Log	*/
/*	Backup Information	*/
DECLARE	@BackupFileName NVARCHAR(100),
		/*	Set this to the folder path where the backup file is located. Include the trailing '\'
			This path can be a local path (C:\Temp\Backups\), if the file was copied locally or a network path (\\msvdidcsql01\CARESBU\Cares)
		*/
		@BackupPathName	NVARCHAR(100) = '\\msvdidcsql01\CARESBU\Cares\$(BackupFileName).$(Extension)',	
		@BackupFullPath	NVARCHAR(200);

SET	@BackupFileName = 'visualguard_2019-01-23-172021';	--	Include the BAK file extension
SET	@BackupFullPath = REPLACE(@BackupPathName , '$(BackupFileName)', @BackupFileName);

DECLARE		@DatabaseName		NVARCHAR(40) -- = LEFT('$(BackupFileName)', CHARINDEX( '_' + CONVERT(CHAR(04), YEAR(GETDATE())), '$(BackupFileName)') -1) 
SET @DatabaseName = LEFT('$(BackupFileName)', CHARINDEX( '_' + CONVERT(CHAR(04), YEAR(GETDATE())), '$(BackupFileName)') -1) 
		
/*	Local Instance Information	*/
DECLARE	@InstanceName		NVARCHAR(40),	-- This is the name of the local instance of SQL Server installed on the machine.
		@LocalFolderPath	NVARCHAR(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL13.$(InstanceName)\MSSQL\DATA\'+@DatabaseName+'.$(Extension)',
		@DatabaseExtension	NCHAR(3) = 'mdf',
		@IndexExtension		NCHAR(3) = 'ndf',
		@LogExtension		NCHAR(3) = 'ldf',
		@DatabasePath		NVARCHAR(400) ='',
		@IndexPath			NVARCHAR(400),
		@LogPath			NVARCHAR(400);

SET @InstanceName = CONVERT(NVARCHAR(40), ISNULL(SERVERPROPERTY('InstanceName'),'MSSQLServer'));
SET @DatabasePath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '$(InstanceName)', @InstanceName), @DatabaseName, @DatabaseName), '$(Extension)', @DatabaseExtension);
SET @IndexPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '$(InstanceName)', @InstanceName), @DatabaseName, @DatabaseName), '$(Extension)', @IndexExtension);
SET @LogPath = REPLACE(REPLACE(REPLACE(@LocalFolderPath, '$(InstanceName)', @InstanceName), @DatabaseName, @DatabaseName), '$(Extension)', @LogExtension);

PRINT @InstanceName
PRINT @DatabasePath
PRINT @IndexPath
PRINT @LogPath
print @BackupFileName
/*	This closes any existing connections that may be open to the database that is being restored.	*/
--IF (EXISTS (SELECT name FROM master.sys.databases WHERE name = @DatabaseName))
--BEGIN
--	EXECUTE('ALTER DATABASE [' + @DatabaseName + '] SET OFFLINE WITH ROLLBACK IMMEDIATE');
--END

--SELECT @BackupFullPath, @DatabasePath, @IndexPath, @LogPath;
 
IF '$(DatabaseName)' = N'db4_ee' 
BEGIN
	/*	Backup Information	*/
	PRINT 1
	RESTORE DATABASE [db4_ee] FROM  DISK = '$(BackupFullPath)'
	WITH REPLACE;
END
ELSE IF '$(DatabaseName)' = N'staging' 
BEGIN
PRINT 2
	RESTORE DATABASE [staging] FROM  DISK = '$(BackupFullPath)'
	WITH REPLACE;
END
ELSE IF '$(DatabaseName)' = N'log'
BEGIN
PRINT 3
	RESTORE DATABASE [Log] FROM  DISK = '$(BackupFullPath)'
	WITH REPLACE;
END
ELSE IF LEFT(@DatabaseName, 11) = N'VisualGuard'
BEGIN
	RESTORE DATABASE [VisualGuard] FROM  DISK = '$(BackupFullPath)'
	WITH REPLACE;
END



 