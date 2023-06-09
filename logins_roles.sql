SELECT 
  LoginName,
  dbName DefaultDB,
  DenyLogin,
  HasAccess,
  SysAdmin,
  SecurityAdmin,
  ServerAdmin,
  SetupAdmin,
  ProcessAdmin,
  DiskAdmin,
  DbCreator,
  BulkAdmin,
  1 [Public],
  IsNtUser,
  IsNtGroup
FROM sys.syslogins 
WHERE
  LoginName NOT LIKE '%Certificate%'
ORDER BY
  DenyLogin,
  LoginName