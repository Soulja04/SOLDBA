
---- to find foreign keys

USE YourDatabaseName
    GO
    Select 
    Schema_name(Schema_id) as SchemaName,
    object_name(Parent_object_id) as TableName,
    name as ForeignKeyConstraintName
    from sys.foreign_keys

------to drop
 Alter table dbo.Orders
    Drop Constraint FK__Orders__Customer__164452B1

------to add
ALTER TABLE dbo.Orders
ADD CONSTRAINT FK__Orders__Customer__164452B1
FOREIGN KEY (Customer_id) REFERENCES Customer(CustomerId);
------

ALTER TABLE dbo.Orders
ADD FOREIGN KEY (Customer_id) REFERENCES Customer(CustomerId);

---to drop all the foreign keys in the database 
--USE YourdatabaseName
--go
---- Drop Foreign Key Constraints Script 
--SELECT distinct 'ALTER TABLE ' 
--+ '['+ Schema_name(FK.schema_id) 
--+ '].['+ OBJECT_NAME(FK.parent_object_id) 
--+ ']'+ ' DROP  CONSTRAINT ' 
--+ '[' + FK.name + ']' AS DropConstraintQuery
-- FROM   sys.foreign_keys AS FK