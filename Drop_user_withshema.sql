
USE staging;
SELECT s.name
FROM sys.schemas s
WHERE s.principal_id = USER_ID('MS000820');

ALTER AUTHORIZATION ON SCHEMA::db_datareader TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_datawriter TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_ddladmin TO dbo;

DROP USER MS000820