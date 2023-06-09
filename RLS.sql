Alter FUNCTION fn_RowLevelSecurity (@FilterName AS sysname)
RETURNS TABLE
WITH SCHEMABINDING
as
RETURN SELECT 1 as fn_SecureApp_enrollData
where @FilterName = user_NAME()
OR user_NAME() = 'Selamu'


 CREATE SECURITY POLICY Filter_App_enroll
ADD FILTER PREDICATE dbo. fn_RowLevelSecurity (UPDATED_BY)
ON [dbo].[app_enroll]
WITH (STATE = ON);

CREATE USER ca1jbush WITHOUT LOGIN 
CREATE USER ElgSavi WITHOUT LOGIN
CREATE USER testuser WITHOUT LOGIN
CREATE USER Alem WITHOUT LOGIN 

GRANT SELECT ON [dbo].[app_enroll] TO ca1jbush
GRANT SELECT ON [dbo].[app_enroll] TO selamu
GRANT SELECT ON [dbo].[app_enroll] TO Alem, testuser

GRANT SELECT ON [dbo].[app_enroll] TO [MS-MEDICAID\MS000967]

SELECT * FROM [dbo].[app_enroll] 


EXECUTE AS USER = 'ca1jbush'
SELECT * FROM  [dbo].[app_enroll]
REVERT


EXECUTE AS USER = 'ElgSavi'
SELECT * FROM  [dbo].[app_enroll]
REVERT

EXECUTE AS USER = 'selamu'
SELECT * FROM [dbo].[app_enroll]
REVERT



EXECUTE AS USER = 'Alem'
SELECT * FROM  [dbo].[app_enroll]
REVERT



BEGIN CREATE USER  Selamu FOR LOGIN [MS-MEDICAID\MS000967] WITH DEFAULT_SCHEMA = [dbo] END; 