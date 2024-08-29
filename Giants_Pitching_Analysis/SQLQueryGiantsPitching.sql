SELECT * 
FROM GiantsPitching.dbo.GiantsPitchingStats

SELECT *
FROM GiantsPitching.dbo.LastPitch

--AVG Pitches Per at Bat Analysis

--a AVG Pitches Per At Bat (LastPitch)

SELECT AVG(1.0*pitch_number) AvgNumofPitchesPerBat
FROM GiantsPitching.dbo.LastPitch

--b AVG Pitches Per At Bat Home Vs Away (LastPitch) -> Union

SELECT 
	--returns column TypeOfGame with value 'Home' for every row in result
	'Home' as TypeOfGame,
	AVG(1.0*pitch_number) AvgNumOfPitchesBat
FROM GiantsPitching.dbo.LastPitch
WHERE home_team = 'SF'

UNION

SELECT 
	'Away' as TypeOfGame,
	AVG(1.0*pitch_number) AvgNumOfPitchesBat
FROM GiantsPitching.dbo.LastPitch
WHERE away_team = 'SF'




--c AVG Pitches Per At Bat Lefty Vs Righty  -> Case Statement 

SELECT
	AVG(CASE WHEN Batter_position = 'R' THEN 1.00 * pitch_number END) RightyBat,
	AVG(CASE WHEN Batter_position = 'L' THEN 1.00 * pitch_number END) LeftyBat
FROM GiantsPitching.dbo.LastPitch

--d AVG Pitches Per At Bat Lefty Vs Righty Pitcher | Each Away Team -> Partition By

SELECT DISTINCT
	home_team,
	Pitcher_position,
	AVG(1.00 * Pitch_number) OVER (Partition by home_team, Pitcher_position) AvgPitchNum
FROM GiantsPitching.dbo.LastPitch
Where away_team = 'SF'

	

--e Top 3 Most Common Pitch for at bat 1 through 10, and total amounts (LastPitch)

--Use With to get

WITH totalpitchsequence AS (
	SELECT DISTINCT
		pitch_name,
		pitch_number,
		COUNT(pitch_name) OVER (PARTITION BY pitch_name, pitch_number) PitchFreq
	FROM GiantsPitching.dbo.LastPitch
	WHERE pitch_number <= 10
),
pitchfrequencyrankquery AS (
	SELECT
		pitch_name,
		pitch_number,
		PitchFreq,
		rank() OVER (PARTITION BY pitch_number ORDER BY PitchFreq DESC) PitchFreqRanking
	FROM totalpitchsequence
)
SELECT *
FROM pitchfrequencyrankquery
WHERE PitchFreqRanking <= 3
		


--f AVG Pitches Per at Bat Per Pitcher with 20+ Innings | Order in descending (LastPitch + GiantsPitchingStats)

SELECT
	gps.name,
	AVG(1.00*pitch_number) AVGPitches
FROM GiantsPitching.dbo.LastPitch lp
JOIN GiantsPitching.dbo.GiantsPitchingStats gps
	ON gps.pitcher_id = lp.pitcher
WHERE IP >= 20
GROUP BY gps.Name
ORDER BY AVGPitches DESC
