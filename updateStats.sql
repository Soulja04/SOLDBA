SELECT * 
FROM sys.all_objects
WHERE name LIKE '%stats%'

/*
	sp_autostats
	sp_updatestats
	sp_createstats
	sys.stats, sys.stats_columns
	STATS_DATE()
	DBCC SHOW_STATISTICS
*/

-- The database has auto create stats and auto update stats enabled
EXEC sp_autostats 'dbo.DateDimension'
	, 'ON'

SELECT d.Year
FROM dbo.DateDimension d
WHERE d.Day = 2

SELECT *, STATS_DATE(object_id, stats_id) AS StatsDate
FROM sys.stats
WHERE auto_created = 1
	AND object_id> 100

SELECT *
FROM sys.stats_columns
WHERE object_id = 1301579675
	AND stats_id = 2

SELECT * FROM sys.columns 
WHERE object_id = 1301579675 

DBCC SHOW_STATISTICS('dbo.DateDimension', 'PK_DateDimension')

CREATE STATISTICS stats_DateDimension_Quarter 
ON dbo.DateDimension(Quarter)
WITH FULLSCAN
GO

SELECT *, STATS_DATE(object_id, stats_id) AS StatsDate
FROM sys.stats
WHERE object_id = 1301579675

DBCC SHOW_STATISTICS('dbo.DateDimension', 'stats_DateDimension_Quarter')
WITH DENSITY_VECTOR -- HISTOGRAM, STATS_HEADER


DBCC SHOW_STATISTICS('dbo.DateDimension', '_WA_Sys_00000005_4D94879B')
WITH HISTOGRAM -- DENSITY_VECTOR , STATS_HEADER

SELECT Quarter, COUNT(*)
FROM dbo.DateDimension
GROUP BY Quarter

SELECT Day, COUNT(*)
FROM dbo.DateDimension
GROUP BY Day

-- Sometimes auto-update stats is too slow - it can't keep up
--		with the speed of the changes
EXEC sp_updatestats

UPDATE STATISTICS dbo.DateDimension

UPDATE STATISTICS dbo.DateDimension stats_DateDimension_Quarter

UPDATE STATISTICS dbo.DateDimension stats_DateDimension_Quarter
	WITH FULLSCAN, NORECOMPUTE
GO