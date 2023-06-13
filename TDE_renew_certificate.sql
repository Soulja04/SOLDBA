
--Create new cert for test**
USE [master]
GO

CREATE CERTIFICATE TDECert_renew
WITH SUBJECT = 'New TDE DEK Certificate',
EXPIRY_DATE = '20200208';
GO 

--alter the databse encryption certificate

USE [db4_ee]
GO
ALTER DATABASE ENCRYPTION KEY
ENCRYPTION BY SERVER CERTIFICATE TDECert_renew;
GO

USE [staging]
GO
ALTER DATABASE ENCRYPTION KEY
ENCRYPTION BY SERVER CERTIFICATE TDECert_renew;
GO

--verify it

USE [master]
GO
SELECT
DB_NAME(db.database_id) DbName, db.encryption_state
, encryptor_type, cer.name, cer.expiry_date, cer.subject
FROM sys.dm_database_encryption_keys db
JOIN sys.certificates cer 
ON db.encryptor_thumbprint = cer.thumbprint
GO


--backup certificate

USE [master]
GO

BACKUP CERTIFICATE TDECert_renew
TO FILE = 'D:\DBA\Cares\TDE\TDE_08_01_2019\TDECert_renew.cer'
WITH PRIVATE KEY (FILE = 'D:\DBA\Cares\TDE\TDE_08_01_2019\TDECert_renew.pvk',
ENCRYPTION BY PASSWORD = 'y4.daLddfdwdw');
GO 
--efefcewfwef.
--drop old certificate if it doesn't needed

USE [master]
GO

DROP CERTIFICATE TDECert;
GO 

