--A database can go in suspect mode for many reasons like improper shutdown of the database server, corruption of the database files etc.

--To get the exact reason of a database going into suspect mode can be found using the following query,

DBCC CHECKDB ('YourDBname') WITH NO_INFOMSGS, ALL_ERRORMSGS

--Output of the above query will give the errors in the database.

--To repair the database, run the following queries in Query Analyzer,

EXEC sp_resetstatus 'yourDBname'; 

ALTER DATABASE yourDBname SET EMERGENCY 

DBCC checkdb('yourDBname') 

ALTER DATABASE yourDBname SET SINGLE_USER WITH ROLLBACK IMMEDIATE 

DBCC CheckDB ('yourDBname', REPAIR_ALLOW_DATA_LOSS) 

ALTER DATABASE yourDBname SET MULTI_USER

--and you are done.