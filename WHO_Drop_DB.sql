SELECT
Operation,
SUSER_SNAME([Transaction SID]) As UserName,
[Transaction Name],
[Begin Time],
[SPID],
Description
FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] = 'dbdestroy'---'DROPOBJ'

---replace the SID
SELECT SUSER_SNAME(0x0105000000000005150000009F11BA296C79F97398D0CF19E8030000) 