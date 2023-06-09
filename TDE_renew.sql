
--Create new cert for test**
USE [master]
GO

CREATE CERTIFICATE TDE_cert_testbr
WITH SUBJECT = 'New TDE DEK Certificate'

GO 

--alter the databse encryption certificate

USE [db4_ee]
GO
ALTER DATABASE ENCRYPTION KEY
ENCRYPTION BY SERVER CERTIFICATE TDE_cert_testbr;
GO

USE [staging]
GO
ALTER DATABASE ENCRYPTION KEY
ENCRYPTION BY SERVER CERTIFICATE TDE_cert_testbr;
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

BACKUP CERTIFICATE TDECert_renewed_test
TO FILE = 'D:\DBA\TDE_certs_Test\TDE_cert_testbr.cer'
WITH PRIVATE KEY (FILE = 'D:\DBA\TDE_certs_Test\TDE_cert_testbr.pvk',
ENCRYPTION BY PASSWORD = 'y4.daLj8EJs4\-cn5a1T.');
GO 
--y4.daLj8EJs4\-cn5a1T.
--drop old certificate if it doesn't needed

USE [master]
GO

DROP CERTIFICATE TDECert_renewed_test;
GO 