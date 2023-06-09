


--- cant do this
ALTER INDEX IX_NC_TableName_ColumnName
FOR TableName(ColumnName)
INCLUDE(Col1, Col2, Col3)

--or
CREATE INDEX IX_NC_TableName_ColumnName
ON TableName(ColumnName)
INCLUDE(Col1, Col2, Col3, Col4)
WITH(DROP_EXISTING = ON);