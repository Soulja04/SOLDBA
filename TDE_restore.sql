
USE master;  
DROP MASTER KEY;  
GO  


USE master
GO


CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'wfdwfwdwdwd'


USE [master]
GO



CREATE CERTIFICATE TDECert_Renew
FROM FILE ='D:\DBA\TDE_certs_Test\TDECert_renew.cer'   
WITH PRIVATE KEY (FILE = 'D:\DBA\TDE_certs_Test\TDECert_renew.pvk', 
DECRYPTION BY PASSWORD = 'fewfwfwwww')

USE [master]
RESTORE DATABASE [TDE_Test] FROM  DISK = N'F:\Backup\TDE_Test_withtde.bak' 
WITH  FILE = 1, NOUNLOAD,  REPLACE,  STATS = 5


SELECT * FROM sys.symmetric_keys

USE master;  
DROP MASTER KEY;  
GO  


USE master
GO


CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'wfdwfwdwd23'


USE [master]
GO



CREATE CERTIFICATE TDECert_Renew
FROM FILE ='D:\DBA\TDE_certs_Test\TDECert_renew.cer'   
WITH PRIVATE KEY (FILE = 'D:\DBA\TDE_certs_Test\TDECert_renew.pvk', 
DECRYPTION BY PASSWORD = 'wfwdwdwd22d')

USE [master]
RESTORE DATABASE [TDE_Test] FROM  DISK = N'F:\Backup\TDE_Test_withtde.bak' 
WITH  FILE = 1, NOUNLOAD,  REPLACE,  STATS = 5


SELECT * FROM sys.symmetric_keys

USE [master]
GO
SELECT
DB_NAME(db.database_id) DbName, db.encryption_state
, encryptor_type, cer.name, cer.expiry_date, cer.subject
FROM sys.dm_database_encryption_keys db
JOIN sys.certificates cer 
ON db.encryptor_thumbprint = cer.thumbprint
GO
