
SELECT * FROM db4_ee.sys.database_files

SELECT * FROM staging.sys.database_files

db4_ee_Test	H:\Mac4\PrimaryData\db4_ee_Test.mdf
db4_ee_Test_log	L:\Mac4\db4_ee_Test_log.ldf
db4_ee_index	H:\Mac4\PrimaryData\db4_ee_index.ndf
Rule_payload_xml	H:\Mac4\PrimaryData\db4_ee_rulepayload.ndf

ALTER DATABASE [db4_ee] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
go

 USE master
GO
ALTER DATABASE [db4_ee] SET multi_user 


ALTER DATABASE db4_ee SET OFFLINE; 
GO	


ALTER DATABASE db4_ee 
MODIFY FILE (
    NAME = 'db4_ee_index',
	FILENAME = 'H:\SecondaryData\CaresMAC2\db4_ee_index.ndf'
)
GO

ALTER DATABASE db4_ee 
MODIFY FILE (
    NAME = 'db4_ee_index2',
	FILENAME = 'H:\SecondaryData\CaresMAC2\db4_ee_index2.ndf'
)
GO

ALTER DATABASE db4_ee
MODIFY FILE (
    NAME = 'db4_ee_Rulepayloadxml_2',
	FILENAME = 'H:\SecondaryData\CaresMAC2\db4_ee_rulepayloadxml_n.ndf'
)
GO

ALTER DATABASE db4_ee SET ONLINE;
GO	
 