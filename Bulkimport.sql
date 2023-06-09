/*
	Eight steps to performing a bulk import:

	1) Backup the log
	2) Switch to BULK_LOGGED recovery model
	3) Disable/drop nonclustered indexes
	4) Import
	5) Backup the log
	6) Rebuild indexes
	7) Switch back to FULL recovery model
	8) Backup the log

*/

USE LearnItFirst171
GO
/*

DROP TABLE dbo.DimOrderDetail
GO

*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.DimOrderDetail (
	SalesOrderID int NOT NULL,
	SalesOrderDetailID int NOT NULL,
	ProductID int NOT NULL,
	ProductName_English NVARCHAR(50) NOT NULL,
	ProductDescription_English NVARCHAR(400) NOT NULL,
	ProductName_French NVARCHAR(50) NOT NULL,
	ProductDescription_French NVARCHAR(400) NOT NULL,
	CONSTRAINT PK_SOD PRIMARY KEY(SalesOrderID, SalesOrderDetailID)
)
GO
CREATE INDEX nci_DimOrderDetail_SalesOrderDetailId_English
ON dbo.DimOrderDetail(SalesOrderDetailId)
INCLUDE (ProductName_English, ProductDescription_English)
GO
CREATE INDEX nci_DimOrderDetail_Name_English
ON dbo.DimOrderDetail(ProductName_English)
INCLUDE (ProductDescription_English)
GO
CREATE INDEX nci_DimOrderDetail_Description_English
ON dbo.DimOrderDetail(ProductDescription_English)
INCLUDE (ProductName_English)
GO

CREATE INDEX nci_DimOrderDetail_SalesOrderDetailId_French
ON dbo.DimOrderDetail(SalesOrderDetailId)
INCLUDE (ProductName_French, ProductDescription_French)
GO
CREATE INDEX nci_DimOrderDetail_Name_French
ON dbo.DimOrderDetail(ProductName_French)
INCLUDE (ProductDescription_French)
GO
CREATE INDEX nci_DimOrderDetail_Description_French
ON dbo.DimOrderDetail(ProductDescription_French)
INCLUDE (ProductName_French)
GO

SELECT * FROM dbo.DimOrderDetail

BULK INSERT dbo.DimOrderDetail
FROM 'C:\Import\171_Ch08_22_BulkImport.dat'
   WITH (
	  FORMATFILE='C:\Import\171_Ch08_22_BulkImport.fmt'
);
GO

TRUNCATE TABLE dbo.DimOrderDetail
BACKUP LOG LearnItFirst171 TO DISK = 'LIF171Log.bak'


ALTER INDEX nci_DimOrderDetail_SalesOrderDetailId_English 
ON dbo.DimOrderDetail DISABLE
ALTER INDEX nci_DimOrderDetail_Name_English 
ON dbo.DimOrderDetail DISABLE
ALTER INDEX nci_DimOrderDetail_Description_English 
ON dbo.DimOrderDetail DISABLE

ALTER INDEX nci_DimOrderDetail_SalesOrderDetailId_French 
ON dbo.DimOrderDetail DISABLE
ALTER INDEX nci_DimOrderDetail_Name_French 
ON dbo.DimOrderDetail DISABLE
ALTER INDEX nci_DimOrderDetail_Description_French 
ON dbo.DimOrderDetail DISABLE

-- Rebuild:

ALTER INDEX nci_DimOrderDetail_SalesOrderDetailId_English 
ON dbo.DimOrderDetail REBUILD
ALTER INDEX nci_DimOrderDetail_Name_English 
ON dbo.DimOrderDetail REBUILD
ALTER INDEX nci_DimOrderDetail_Description_English 
ON dbo.DimOrderDetail REBUILD

ALTER INDEX nci_DimOrderDetail_SalesOrderDetailId_French 
ON dbo.DimOrderDetail REBUILD
ALTER INDEX nci_DimOrderDetail_Name_French 
ON dbo.DimOrderDetail REBUILD
ALTER INDEX nci_DimOrderDetail_Description_French 
ON dbo.DimOrderDetail REBUILD
