-- Srored Procedure to generate Security Audit report in HTML format:

CREATE PROC spAuditUsersPermissions
AS
SET NOCOUNT ON

DECLARE @sql VARCHAR(MAX)
DECLARE @strHTML VARCHAR(MAX)
DECLARE @i INT
DECLARE @rc INT
DECLARE @dbname VARCHAR(400)

-----------------Print header of the report--------------------

SELECT @strHTML = '<HTML><HEAD><TITLE> Security list for the auditor </TITLE><STYLE>TD.Sub{FONT-WEIGHT:bold;BORDER-BOTTOM: 0pt solid #000000;BORDER-LEFT: 1pt solid #000000;BORDER-RIGHT: 0pt solid #000000;BORDER-TOP: 0pt solid #000000; FONT-FAMILY: Tahoma;FONT-SIZE: 8pt} BODY{FONT-FAMILY: Tahoma;FONT-SIZE: 8pt} TABLE{BORDER-BOTTOM: 1pt solid #000000;BORDER-LEFT: 0pt solid #000000;BORDER-RIGHT: 1pt solid #000000;BORDER-TOP: 0pt solid #000000; FONT-FAMILY: Tahoma;FONT-SIZE: 8pt} TD{BORDER-BOTTOM: 0pt solid #000000;BORDER-LEFT: 1pt solid #000000;BORDER-RIGHT: 0pt solid #000000;BORDER-TOP: 1pt solid #000000; FONT-FAMILY: Tahoma;FONT-SIZE: 8pt} TD.Title{FONT-WEIGHT:bold;BORDER-BOTTOM: 0pt solid #000000;BORDER-LEFT: 1pt solid #000000;BORDER-RIGHT: 0pt solid #000000;BORDER-TOP: 1pt solid #000000; FONT-FAMILY: Tahoma;FONT-SIZE: 12pt} A.Index{FONT-WEIGHT:bold;FONT-SIZE:8pt;COLOR:#000099;FONT-FAMILY:Tahoma;TEXT-DECORATION:none} A.Index:HOVER{FONT-WEIGHT:bold;FONT-SIZE:8pt;COLOR:#990000;FONT-FAMILY:Tahoma;TEXT-DECORATION:none}</STYLE></HEAD><BODY><A NAME="_top"></A><BR>'
PRINT @strHTML

-----------------Login information-------------------------------------------------------------

SELECT ROW_NUMBER () OVER (ORDER BY name) AS RowNumber,
name, dbname,language, 
CONVERT(CHAR(10),CASE denylogin WHEN 1 THEN 'X' ELSE '--' END) AS IsDenied,
CONVERT(CHAR(10),CASE isntname WHEN 1 THEN 'X' ELSE '--' END) AS IsWinAuTHENtication,
CONVERT(CHAR(10),CASE isntgroup WHEN 1 THEN 'X' ELSE '--' END) AS IsWinGroup,
createdate,UPDATEdate,
CONVERT(VARCHAR(2000),
CASE sysadmin WHEN 1 THEN 'sysadmin,' ELSE '' END +
CASE securityadmin WHEN 1 THEN 'securityadmin,' ELSE '' END +
CASE serveradmin WHEN 1 THEN 'serveradmin,' ELSE '' END +
CASE setupadmin WHEN 1 THEN 'setupadmin,' ELSE '' END +
CASE processadmin WHEN 1 THEN 'processadmin,' ELSE '' END +
CASE diskadmin WHEN 1 THEN 'diskadmin,' ELSE '' END +
CASE dbcreator WHEN 1 THEN 'dbcreator,' ELSE '' END +
CASE bulkadmin WHEN 1 THEN 'bulkadmin' ELSE '' END ) AS ServerRoles
INTO #syslogins
FROM master..syslogins WITH (nolock)
ORDER BY name

SET @rc = @@rowcount

SELECT @strHTML = '<BR><CENTER><FONT SIZE="5"><B> Server ' + @@servername + '</B></FONT></CENTER><BR>'
PRINT @strHTML
PRINT '<DIV ALIGN="center"><TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="100%">'

-- Query the data only if there are rows:
IF @rc = 0
BEGIN
   PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="1" ALIGN="center"><B><A NAME="_LoginInfomration">Logins information</A></B> </TD></TR>'
   PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>There are no logins on this server</B> </TD></TR>'
END
ELSE
BEGIN
   UPDATE #syslogins
   SET ServerRoles = SUBSTRING(ServerRoles,1,LEN(ServerRoles)-1)
   WHERE SUBSTRING(ServerRoles,LEN(ServerRoles),1) = ','

   UPDATE #syslogins SET ServerRoles = '--'
   WHERE LTRIM(RTRIM(ServerRoles)) = ''

   PRINT '<DIV ALIGN="center"><TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="100%">'
   PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="9" ALIGN="center"><B><A NAME="_LoginInfomration">Logins information</A></B> </TD></TR>'
   PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="50%"><B>Login Name</B> </TD><TD ALIGN="left" WIDTH="50%"><B>Default DB</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Language</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Denied acess?</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Windows Auth?</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Window group?</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Date created</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Date UPDATEd</B> </TD><TD AALIGN="left" WIDTH="770%"><B>Server roles</B> </TD></TR>'

   SET @i = 1
   WHILE @i <= @rc
   BEGIN
       SELECT @strHTML = 
       '<TR><TD><B>' + CONVERT(VARCHAR(50),name) + '</B> </TD>' + 
       '<TD>' + CONVERT(VARCHAR(50),CASE ISNULL(dbname,'--') WHEN '' THEN '--' ELSE ISNULL(dbname,'--') END) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(50),ISNULL(language,'--')) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(10),ISNULL(IsDenied,'--')) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(10),ISNULL(IsWinAuTHENtication,'--')) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(10),ISNULL(IsWinGroup,'--')) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(30),ISNULL(createdate,'--')) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(30),ISNULL(UPDATEdate,'--')) + ' </TD>' +
       '<TD>' + CONVERT(VARCHAR(100),ISNULL(ServerRoles,'--')) + ' </TD>' +
       '</TR>'
       FROM #syslogins
       WHERE RowNumber = @i

       PRINT @strHTML

       SET @i = @i + 1
   END

   PRINT '</TABLE></DIV><BR><A CLASS="Index" HREF="#_top">Back To Top ^</A><BR><BR>'
   PRINT'<BR><CENTER></CENTER><BR>'
END

DROP TABLE #syslogins

---------------Fetch data per database-------------------------------------------------

CREATE TABLE #LoginMap (LoginName VARCHAR(200), UserName VARCHAR(200) NULL)

CREATE TABLE #RoleUser (RoLEName VARCHAR(200), UserName VARCHAR(200) NULL)

CREATE TABLE #ObjectPerms (RowNumber INT IDENTITY, UserName VARCHAR(50), PerType VARCHAR(10),PermName VARCHAR(30), SchemaName VARCHAR(50), 
ObjectName VARCHAR(100), ObjectType VARCHAR(20), ColName VARCHAR(50), IsGrantOption VARCHAR(10))

CREATE TABLE #DatabasePerms (RowNumber INT IDENTITY,UserName VARCHAR(50),PermType VARCHAR(20),PermName VARCHAR(50),IsGrantOption VARCHAR(5))

DECLARE dbs CURSOR FOR SELECT name FROM master..sysdatabases ORDER BY name

OPEN dbs
FETCH NEXT FROM dbs INTO @dbname
WHILE @@FETCH_STATUS = 0
BEGIN
   TRUNCATE TABLE #LoginMap
   TRUNCATE TABLE #RoleUser
   TRUNCATE TABLE #ObjectPerms 
   TRUNCATE TABLE #DatabasePerms
   SELECT @strHTML = '<BR><CENTER><FONT SIZE="5"><B> Database ' + @dbname + '</B></FONT></CENTER><BR>'
   PRINT @strHTML

-----------------Mapping of logins to users------------------
   EXEC('
INSERT INTO #LoginMap
SELECT login.loginname,users.name 
FROM ['+ @dbname+'].dbo.sysusers users 
INNER JOIN [master].[dbo].[syslogins] login 
ON users.[sid] = login.[sid]
WHERE users.uid < 16382 
and users.name not in (''public'',''dbo'',''guest'')
')

   SET @strHTML = ''

   PRINT '<DIV ALIGN="center"><TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="60%">'

   --Query the data only if there are rows
   IF NOT EXISTS (SELECT 1 FROM #LoginMap)
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="1" ALIGN="center"><B><A NAME="_LoginMapping">Mapping of logins to users</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>There are no mappings in this database</B> </TD></TR>'
   END 
   ELSE
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="2" ALIGN="center"><B><A NAME="_LoginMapping">Mapping of logins to users</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>Login Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>User Name</B> </TD></TR>'

       SELECT @strHTML = @strHTML + 
       '<TR><TD><B>' + CONVERT(VARCHAR(50),LoginName) + '</B> </TD><TD>' + CONVERT(VARCHAR(50),ISNULL(UserName,'')) + ' </TD></TR>' + CHAR(10)
       FROM #LoginMap
       ORDER BY LoginName

       PRINT @strHTML
   END

   PRINT '</TABLE></DIV><BR><A CLASS="Index" HREF="#_top">Back To Top ^</A><BR><BR>'

   ----------------SQL roles per user------------------
   EXEC ('INSERT INTO #RoleUser
SELECT b.name AS Role_name, a.name AS User_name ' + 
   'FROM ['+ @dbname+']..sysusers a ' +
   'INNER JOIN ['+ @dbname+ ']..sysmembers c on a.uid = c.memberuid ' +
   'INNER JOIN ['+ @dbname+ ']..sysusers b ON c.groupuid = b.uid ' + 
   'WHERE a.name <> ''dbo'''
   ) 

   SET @strHTML = ''

   PRINT '<DIV ALIGN="center"><TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="60%">'

   -- Query the data only if there are rows:

   IF NOT EXISTS(SELECT 1 FROM #RoleUser)
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="1" ALIGN="center"><B><A NAME="_DBRoleMapping">Roles per user</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>There are no users mapped to roles in this database</B> </TD></TR>'
   END 
   ELSE
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="2" ALIGN="center"><B><A NAME="_DBRoleMapping">Roles per user</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>Role Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>User Name</B> </TD></TR>'

       SELECT @strHTML = @strHTML + 
       '<TR><TD><B>' + CONVERT(VARCHAR(50),RoLEName) + '</B> </TD><TD>' + CONVERT(VARCHAR(50),ISNULL(UserName,'')) + ' </TD></TR>' + CHAR(10)
       FROM #RoleUser
       ORDER BY RoLEName

       PRINT @strHTML
   END
   
   PRINT '</TABLE></DIV><BR><A CLASS="Index" HREF="#_top">Back To Top ^</A><BR><BR>'

----------------Database level Permissions-------------------------

   EXEC ('INSERT INTO #DatabasePerms
(UserName,PermType,PermName,IsGrantOption)
SELECT usr.name,
CASE WHEN perm.state <> ''W'' THEN perm.state_desc ELSE ''GRANT'' END,
perm.permission_name, 
CASE WHEN perm.state != ''W'' THEN ''--'' ELSE ''X'' END AS IsGrantOption
FROM ['+@dbname+'].sys.database_permissions AS perm
INNER JOIN
['+@dbname+'].sys.database_principals AS usr
ON perm.grantee_principal_id = usr.principal_id
WHERE perm.major_id = 0
ORDER BY usr.name, perm.permission_name ASC, perm.state_desc ASC'
   )

   SET @rc = @@rowcount

   PRINT '<DIV ALIGN="center"><TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="60%">'

   -- Query the data only if there are rows:
   
   IF NOT EXISTS(SELECT 1 FROM #DatabasePerms)
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="1" ALIGN="center"><B><A NAME="_DBLvlPerms">Database level permissions</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>There are no specific permissions on the database level</B> </TD></TR>'
   END 
   ELSE
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN=" 4" ALIGN="center"><B><A NAME="_DBPObjPerms">Database level permissions</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>User Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Permission type</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Permission Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Grant option?</B> </TD></TR>'
       
       SET @i = 1
       WHILE @i <= @rc
       BEGIN
           SELECT @strHTML = 
           '<TR><TD><B>' + CONVERT(VARCHAR(50),UserName) + '</B> </TD>' + 
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(PermType,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(PermName,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(5),ISNULL(IsGrantOption,'--')) + ' </TD>'+
           '</TR>'
           FROM #DatabasePerms
           WHERE Rownumber = @i

           PRINT @strHTML
       
           SET @i = @i + 1
       END
   END

   PRINT '</TABLE></DIV><BR><A CLASS="Index" HREF="#_top">Back To Top ^</A><BR><BR>'

----------------Database object Permissions-------------------------
   EXEC ('INSERT INTO #ObjectPerms
(UserName,PerType,PermName,SchemaName,ObjectName,ObjectType,ColName,IsGrantOption)
SELECT usr.name AS UserName,
CASE WHEN perm.state <> ''W'' THEN perm.state_desc ELSE ''GRANT'' END AS PerType,
perm.permission_name,USER_NAME(obj.schema_id) AS SchemaName, obj.name AS ObjectName,
CASE obj.Type 
WHEN ''U'' THEN ''Table''
WHEN ''V'' THEN ''View''
WHEN ''P'' THEN ''Stored Proc''
WHEN ''FN'' THEN ''Function''
ELSE obj.Type END AS ObjectType,
CASE WHEN cl.column_id IS NULL THEN ''--'' ELSE cl.name END AS ColName,
CASE WHEN perm.state = ''W'' THEN ''X'' ELSE ''--'' END AS IsGrantOption
FROM ['+@dbname+'].sys.database_permissions AS perm
INNER JOIN
['+@dbname+'].sys.objects AS obj
ON perm.major_id = obj.[object_id]
INNER JOIN
['+@dbname+'].sys.database_principals AS usr
ON perm.grantee_principal_id = usr.principal_id
LEFT JOIN
['+@dbname+'].sys.columns AS cl
ON cl.column_id = perm.minor_id AND cl.[object_id] = perm.major_id
WHERE obj.Type <> ''S'' 
ORDER BY usr.name, perm.state_desc ASC, perm.permission_name ASC'
   )

   SET @rc = @@rowcount

   PRINT '<DIV ALIGN="center"><TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="60%">'
   
   -- Query the data only if there are rows:
   IF NOT EXISTS(SELECT 1 FROM #ObjectPerms)
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="1" ALIGN="center"><B><A NAME="_DBPObjPerms">Object permissions</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>There are no specific permissions to objects in this database</B> </TD></TR>'
   END 
   ELSE
   BEGIN
       PRINT '<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="8" ALIGN="center"><B><A NAME="_DBPObjPerms">Object permissions</A></B> </TD></TR>'
       PRINT '<TR BGCOLOR="EEEEEE"><TD ALIGN="left" WIDTH="70%"><B>User Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Permission type</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Permission Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Schema Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Object Name</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Object type type</B> </TD><TD ALIGN="left" WIDTH="70%"><B>Column Name</B> </TD><TD ALIGN=" left" WIDTH="70%"><B>Grant option?</B> </TD></TR>'
   
       SET @i = 1
       WHILE @i <= @rc
       BEGIN
           SELECT @strHTML = 
           '<TR><TD><B>' + CONVERT(VARCHAR(50),UserName) + '</B> </TD>' + 
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(PerType,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(PermName,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(SchemaName,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(ObjectName,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(30),ISNULL(ObjectType,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(50),ISNULL(ColName,'--')) + ' </TD>' +
           '<TD>' + CONVERT(VARCHAR(5),ISNULL(IsGrantOption,'--')) + ' </TD></TR>'
           FROM #ObjectPerms
           WHERE Rownumber = @i

           PRINT @strHTML

           SET @i = @i + 1
       END
   END

   PRINT '</TABLE></DIV><BR><A CLASS="Index" HREF="#_top">Back To Top ^</A><BR><BR>'

   FETCH NEXT FROM dbs INTO @dbname

END

---------------Close cursor and drop all temporary objects-------------

CLOSE dbs
DEALLOCATE dbs

DROP TABLE #LoginMap
DROP TABLE #RoleUser
DROP TABLE #ObjectPerms
DROP TABLE #DatabasePerms

PRINT '</BODY></HTML>'

GO  