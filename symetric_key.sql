USE MASTER 
GO
SELECT encryptor_type, key_length, key_algorithm, encryption_state, create_date 
FROM sys.dm_database_encryption_keys
GO

-------

SELECT name KeyName,
symmetric_key_id KeyID,
key_length KeyLength,
algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-------

USE MASTER 
GO
SELECT * FROM sys.certificates 
WHERE pvt_key_encryption_type <> 'NA'
GO