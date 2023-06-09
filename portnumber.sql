DECLARE @PortNumber VARCHAR(50)
    ,@PATH VARCHAR(100)

IF charindex('\', @@SERVERNAME, 0) <> 0
BEGIN
    SET @PATH = 'SOFTWARE\MICROSOFT\Microsoft SQL Server\' + @@SERVICENAME +
 '\MSSQLServer\Supersocketnetlib\TCP'
END
ELSE
BEGIN
    SET @PATH = 'SOFTWARE\MICROSOFT\MSSQLServer\MSSQLServer \Supersocketnetlib\TCP'
END

EXEC master..xp_regread @rootkey = 'HKEY_LOCAL_MACHINE'
    ,@key = @PATH
    ,@value_name = 'Tcpport'
    ,@value = @PortNumber OUTPUT

SELECT 'SQLServer Instance Name: ' + @@SERVERNAME + ' SQL Server Port Number:' + 
convert(VARCHAR(50), @PortNumber)