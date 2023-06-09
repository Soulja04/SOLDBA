SELECT 
SERVERPROPERTY('Edition') AS 'Edition', 
SERVERPROPERTY('ProductVersion') AS 'ProductVersion', 
SERVERPROPERTY('ProductLevel') AS 'ProductLevel', 
SERVERPROPERTY('ResourceLastUpdateDateTime') AS 'ResourceLastUpdateDateTime', 
SERVERPROPERTY('ResourceVersion') AS 'ResourceVersion' 
GO