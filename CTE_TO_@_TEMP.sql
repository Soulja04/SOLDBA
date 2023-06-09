--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[usp_SELECT_NON_MAGI_PERSON_RACES]
--(
SET STATISTICS IO , TIME ON 
BEGIN TRAN 
DECLARE 
	@PersonId INT = 328981
--)
--AS
-- =============================================
-- Author:		Vinith Golla
-- Create DATE: 01/25/2021
-- Description:	Select Non-magi person races.
-- =============================================
BEGIN
	--SET NOCOUNT ON;
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED;

	--List Races.
	WITH cte_RACES AS
	(
		SELECT	RACE.PERSON_RACE_ID AS PersonRaceId,
				RACE.PERSON_ID AS PersonId,
				IIF(RACE.RACE_ID = 14, 1, 0) AS IsWhite,
				IIF(RACE.RACE_ID = 3, 1, 0) AS IsBlack,
				IIF(RACE.RACE_ID = 1, 1, 0) AS IsAmericanIndian,
				IIF(RACE.RACE_ID IN (2, 4, 7, 8, 10, 13), 1, 0) AS IsAsian,
				IIF(RACE.RACE_ID = 15, 1, 0) AS IsOther,
				IIF(ETHNICITY.ETHNICITY_ID IS NOT NULL, 1, 0) AS IsHispanic,
				--Race.OTHER_RACE AS OtherRace
				STUFF((
							SELECT	',' + RTRIM(LTRIM(RACE1.OTHER_RACE))
							FROM	[dbo].[t_PERSON_RACE] AS RACE1
							WHERE	RACE.PERSON_ID = RACE1.PERSON_ID AND RACE1.OTHER_RACE <> '' AND RACE1.RACE_ID = 15 FOR XML PATH('')), 1, 1, ''
					) AS OtherRace  --15 - Other Race
		FROM	[dbo].[t_PERSON_RACE] AS RACE
				FULL JOIN [dbo].[t_PERSON_ETHNICITY] AS ETHNICITY ON RACE.PERSON_ID = ETHNICITY.PERSON_ID
		WHERE	ETHNICITY.PERSON_ID = @PersonId
				OR RACE.PERSON_ID = @PersonId
	),

	-- Max of races.
	cte_RACES_RECORD AS
	(
		SELECT	PersonId,
				CAST(MAX(IsWhite) AS BIT) AS IsWhite,
				CAST(MAX(IsBlack) AS BIT) AS IsBlack,
				CAST(MAX(IsAmericanIndian) AS BIT) AS IsAmericanIndian,
				CAST(MAX(IsAsian) AS BIT) AS IsAsian,
				CAST(MAX(IsOther) AS BIT) AS IsOther,
				CAST(MAX(IsHispanic) AS BIT) AS IsHispanic
		FROM	cte_RACES
		GROUP BY PersonId
	)

	SELECT	DISTINCT
			RR.PersonId,
			RR.IsWhite,
			RR.IsBlack,
			RR.IsAmericanIndian,
			RR.IsAsian,
			RR.IsOther,
			RR.IsHispanic,
			R.OtherRace
	FROM	CTE_RACES_RECORD AS RR
			LEFT JOIN CTE_RACES R ON RR.PersonId = R.PersonId

	SET TRAN ISOLATION LEVEL READ COMMITTED;
END
SET STATISTICS IO , TIME OFF 
--GO

---rollback



---------to temp table and @
USE db4_ee
GO
SET STATISTICS IO , TIME ON
BEGIN TRAN

DECLARE @otherrace AS VARCHAR(100)
	   ,@PersonId INT = 328981

BEGIN
	--SET NOCOUNT ON;
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED;

	SELECT @otherrace = STUFF((
				SELECT ',' + RTRIM(LTRIM(RACE1.OTHER_RACE))
				FROM [dbo].[t_PERSON_RACE] AS RACE1
				WHERE RACE1.PERSON_ID = RACE1.PERSON_ID
					AND RACE1.OTHER_RACE <> ''
					AND RACE1.RACE_ID = 15
				FOR XML PATH('')
				), 1, 1, '')
	
	--FROM [dbo].[t_PERSON_RACE] AS RACE
	--FULL JOIN [dbo].[t_PERSON_ETHNICITY] AS ETHNICITY ON RACE.PERSON_ID = ETHNICITY.PERSON_ID
	--WHERE ETHNICITY.PERSON_ID = @PersonId
	--	OR RACE.PERSON_ID = @PersonId

	SELECT RACE.PERSON_RACE_ID AS PersonRaceId
		,RACE.PERSON_ID AS PersonId
		,IIF(RACE.RACE_ID = 14, 1, 0) AS IsWhite
		,IIF(RACE.RACE_ID = 3, 1, 0) AS IsBlack
		,IIF(RACE.RACE_ID = 1, 1, 0) AS IsAmericanIndian
		,IIF(RACE.RACE_ID IN (
				2
				,4
				,7
				,8
				,10
				,13
				), 1, 0) AS IsAsian
		,IIF(RACE.RACE_ID = 15, 1, 0) AS IsOther
		,IIF(ETHNICITY.ETHNICITY_ID IS NOT NULL, 1, 0) AS IsHispanic
		,@otherrace AS OtherRace
	INTO #blah
	FROM [dbo].[t_PERSON_RACE] AS RACE
	FULL JOIN [dbo].[t_PERSON_ETHNICITY] AS ETHNICITY ON RACE.PERSON_ID = ETHNICITY.PERSON_ID
	WHERE ETHNICITY.PERSON_ID = @PersonId
		OR RACE.PERSON_ID = @PersonId

	SELECT PersonId
		,CAST(MAX(IsWhite) AS BIT) AS IsWhite
		,CAST(MAX(IsBlack) AS BIT) AS IsBlack
		,CAST(MAX(IsAmericanIndian) AS BIT) AS IsAmericanIndian
		,CAST(MAX(IsAsian) AS BIT) AS IsAsian
		,CAST(MAX(IsOther) AS BIT) AS IsOther
		,CAST(MAX(IsHispanic) AS BIT) AS IsHispanic
	INTO #blahblah
	FROM #blah
	GROUP BY PersonId

	--)
	SELECT DISTINCT RR.PersonId
		,RR.IsWhite
		,RR.IsBlack
		,RR.IsAmericanIndian
		,RR.IsAsian
		,RR.IsOther
		,RR.IsHispanic
		,R.OtherRace
	FROM #blahblah AS RR
	LEFT JOIN #blah AS R ON RR.PersonId = R.PersonId

	SET TRAN ISOLATION LEVEL READ COMMITTED;
END
SET STATISTICS IO , TIME OFF
---rollback





-----to @ variable

USE [db4_ee]
GO
/****** Object:  StoredProcedure [dbo].[usp_SELECT_NON_MAGI_PERSON_RACES]    Script Date: 1/26/2021 9:59:15 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[usp_SELECT_NON_MAGI_PERSON_RACES]
--(
SET STATISTICS IO , TIME ON
BEGIN TRAN 
DECLARE 
	@PersonId INT
--)
--AS
-- =============================================
-- Author:		Vinith Golla
-- Create DATE: 01/26/2021
-- Description:	Select Non-magi person races.
-- =============================================
BEGIN
	--SET NOCOUNT ON;
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @OTHER_RACE VARCHAR(100);

	SELECT @OTHER_RACE = (
							SELECT STUFF((
											SELECT	',' + RTRIM(LTRIM(RACE1.OTHER_RACE))
											FROM	[dbo].[t_PERSON_RACE] AS RACE1
											WHERE	RACE1.PERSON_ID = @PersonId  AND RACE1.OTHER_RACE <> '' AND RACE1.RACE_ID = 15 For XML PATH('')), 1, 1, ''
											) AS OtherRace
						); --15 - Other Race
	-- List Races.
	WITH cte_RACES AS
	(
		SELECT	RACE.PERSON_RACE_ID AS PersonRaceId,
				RACE.PERSON_ID AS PersonId,
				IIF(RACE.RACE_ID = 14, 1, 0) AS IsWhite,
				IIF(RACE.RACE_ID = 3, 1, 0) AS IsBlack,
				IIF(RACE.RACE_ID = 1, 1, 0) AS IsAmericanIndian,
				IIF(RACE.RACE_ID IN (2, 4, 7, 8, 10, 13), 1, 0) AS IsAsian,
				IIF(RACE.RACE_ID = 15, 1, 0) AS IsOther,
				IIF(ETHNICITY.ETHNICITY_ID IS NOT NULL, 1, 0) AS IsHispanic
		FROM	[dbo].[t_PERSON_RACE] AS RACE
				FULL JOIN [dbo].[t_PERSON_ETHNICITY] AS ETHNICITY ON RACE.PERSON_ID = ETHNICITY.PERSON_ID
		WHERE	ETHNICITY.PERSON_ID = @PersonId
				OR RACE.PERSON_ID = @PersonId
	)

	-- Max of races.
		SELECT	PersonId,
				CAST(MAX(IsWhite) AS BIT) AS IsWhite,
				CAST(MAX(IsBlack) AS BIT) AS IsBlack,
				CAST(MAX(IsAmericanIndian) AS BIT) AS IsAmericanIndian,
				CAST(MAX(IsAsian) AS BIT) AS IsAsian,
				CAST(MAX(IsOther) AS BIT) AS IsOther,
				CAST(MAX(IsHispanic) AS BIT) AS IsHispanic,
				@OTHER_RACE AS OtherRace
		FROM	cte_RACES
		GROUP BY PersonId

	SET TRAN ISOLATION LEVEL READ COMMITTED;
END
SET STATISTICS IO , TIME OFF
---rollback