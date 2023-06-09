-------TDE DATABASE LEVEL-------

----BACKUP THE  DATABASE---

USE MASTER 
GO
BACKUP DATABASE CompanySale TO DISK N'H:\BACKUP\CompanySale.bak'
 
 ----create master key---

 USE MASTER
 GO
 CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'p@123456';
 GO

---Create certificate----

CREATE CERTIFICATE CompanySale WITH SUBJECT = 'CompanySale_certificate';
GO

----Create Encryption Key, Encrypted by server Certification-----

USE CompanySale
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE CompanySale;
GO

------backup certificate -----

USE MASTER
GO
BACKUP CERTIFICATE CompanySale
TO FILE = 'H:\CompanySale.bak'
WITH PRIVATE KEY (FILE='H:\CompanySale_Key.pvk', ENCRYPTION BY PASSWORD ='P@123456')
GO

------enable encryption-----

ALTER DATABASE CompanySale 
SET ENCRYPTION  ON ;
GO

-----veryfy Certificate Details-----

USE MASTER 
GO
SELECT * FROM sys.certificates 
WHERE pvt_key_encryption_type <> 'NA'
GO

-------very encryption key details

USE MASTER 
GO
SELECT encryptor_type, key_length, key_algorithm, encryption_state, create_date
FROM sys.dm_database_encryption_keys
GO

----Drop Unencrypted backup file e.g full database backup with recovery------

USE MASTER 
GO
BACKUP DATABASE CompanySale TO DISK = N'H:\BACKUP\CompanySale.bak'
WITH NOFORMAT, NOINIT, NAME = N'CompanySale-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD , STATS = 10
GO
