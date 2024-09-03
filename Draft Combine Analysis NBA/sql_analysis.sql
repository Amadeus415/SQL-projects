SELECT *
FROM NBA_data.dbo.draft_combine_stats

SELECT *
FROM NBA_data.dbo.draft_history


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'draft_combine_stats';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'draft_history';

--Make sure player are correlated based on id in both tables

-- Question 1: Player Performance and Draft Position
-- How do physical attributes (height, weight, wingspan, vertical leap, etc.) correlate with draft position?

SELECT 
	dcs.player_name,
    dh.overall_pick,
    dcs.height_cm,
    dcs.weight,
    dcs.wingspan,
    dcs.standing_vertical_leap,
    dcs.max_vertical_leap,
    dcs.lane_agility_time,
    dcs.bench_press
FROM 
    draft_combine_stats dcs
JOIN 
    draft_history dh 
ON 
	dcs.id = dh.id
ORDER BY overall_pick;

-- Question 2: Trends Over Seasons
-- How have player physical characteristics evolved over different seasons? Are players getting taller, heavier, or more agile?

-- Query 2: Trends in physical characteristics over seasons
SELECT 
    dcs.season,
	ROUND(AVG(dcs.height_cm), 2) AS avg_height,
    ROUND(AVG(dcs.weight), 2) AS avg_weight,
    ROUND(AVG(dcs.standing_vertical_leap), 2) AS avg_vertical_leap,
    ROUND(AVG(dcs.lane_agility_time), 2) AS avg_agility_time
FROM 
    draft_combine_stats dcs
GROUP BY 
    dcs.season
ORDER BY 
    dcs.season;


-- Question 3: Position-Specific Attributes
-- What are the typical physical attributes for different positions (e.g., guards vs. forwards vs. centers)?

-- Query 3: Typical physical attributes for different positions

SELECT 
    dcs.position,
    AVG(dcs.height_cm) AS avg_height,
    AVG(dcs.weight) AS avg_weight,
    AVG(dcs.wingspan) AS avg_wingspan,
    AVG(dcs.standing_vertical_leap) AS avg_vertical_leap,
    AVG(dcs.bench_press) AS avg_bench_press
FROM 
    draft_combine_stats dcs
GROUP BY 
    dcs.position
ORDER BY 
    dcs.position;


-- Question 4: Body Fat Percentage and Performance
-- Is there a correlation between body fat percentage and a player’s agility or sprint times?

-- Query 4: Correlation between body fat percentage and performance

SELECT 
    CASE
        WHEN dcs.body_fat_pct < 5 THEN 'Less than 5%'
        WHEN dcs.body_fat_pct BETWEEN 5 AND 10 THEN '5% to 10%'
        WHEN dcs.body_fat_pct BETWEEN 10 AND 15 THEN '10% to 15%'
        WHEN dcs.body_fat_pct BETWEEN 15 AND 20 THEN '15% to 20%'
        ELSE 'Greater than 20%'
    END AS body_fat_pct_range,
    ROUND(AVG(dcs.lane_agility_time), 2) AS avg_lane_agility_time,
    ROUND(AVG(dcs.three_quarter_sprint), 2) AS avg_three_quarter_sprint,
	ROUND(AVG(dcs.weight), 2) AS avg_weight,
    ROUND(AVG(dcs.standing_vertical_leap), 2) AS avg_vertical_leap
FROM 
    draft_combine_stats dcs
WHERE 
    dcs.body_fat_pct IS NOT NULL
    AND dcs.lane_agility_time IS NOT NULL
    AND dcs.three_quarter_sprint IS NOT NULL
GROUP BY 
    CASE
        WHEN dcs.body_fat_pct < 5 THEN 'Less than 5%'
        WHEN dcs.body_fat_pct BETWEEN 5 AND 10 THEN '5% to 10%'
        WHEN dcs.body_fat_pct BETWEEN 10 AND 15 THEN '10% to 15%'
        WHEN dcs.body_fat_pct BETWEEN 15 AND 20 THEN '15% to 20%'
        ELSE 'Greater than 20%'
    END
ORDER BY 
    MIN(dcs.body_fat_pct);



-- Question 5: Impact of Physical Attributes on Bench Press
-- Do players with longer wingspans and greater hand size perform better or worse in the bench press?

-- Query 5: Impact of wingspan and hand size on bench press performance

-- Calculate the correlation between wingspan, hand size, and bench press performance

SELECT 
    MIN(wingspan) AS min_wingspan,
    MAX(wingspan) AS max_wingspan,
    COUNT(*) AS total_count
FROM 
    draft_combine_stats
WHERE 
    wingspan IS NOT NULL;


SELECT 
    CASE 
        WHEN wingspan < 80 THEN 'Wingspan < 80 in'
        WHEN wingspan BETWEEN 80 AND 90 THEN '80 in <= Wingspan < 90 in'
        ELSE 'Wingspan >= 90 cm'
    END AS wingspan_group,
    AVG(bench_press) AS avg_bench_press
FROM 
    draft_combine_stats
WHERE 
    bench_press IS NOT NULL
    AND wingspan IS NOT NULL
GROUP BY 
    CASE 
        WHEN wingspan < 80 THEN 'Wingspan < 80 in'
        WHEN wingspan BETWEEN 80 AND 90 THEN '80 in <= Wingspan < 90 in'
        ELSE 'Wingspan >= 90 cm'
    END
ORDER BY 
    avg_bench_press;




-- Question 6: Predicting Draft Success
-- Can we predict a player’s draft success based on their combine stats?


SELECT 
    CASE 
        WHEN overall_pick BETWEEN 0 AND 10 THEN 'Top 10 picks'
        WHEN overall_pick BETWEEN 11 AND 25 THEN 'Picks 11-25'
        WHEN overall_pick BETWEEN 26 AND 60 THEN 'Picks 26-60'
        ELSE 'Picks 61 and above'
    END AS pick_group,
    AVG(dcs.height_cm) AS avg_height,
    AVG(dcs.weight) AS avg_weight,
    AVG(dcs.wingspan) AS avg_wingspan,
    AVG(dcs.standing_vertical_leap) AS avg_vertical_leap,
    AVG(dcs.bench_press) AS avg_bench_press
FROM 
    draft_history dh
JOIN
	draft_combine_stats dcs
ON 
	dh.id = dcs.id
WHERE
	dcs.height_cm IS NOT NULL
	AND dcs.weight IS NOT NULL
	AND dcs.wingspan IS NOT NULL
	AND dcs.standing_vertical_leap IS NOT NULL
GROUP BY 
    CASE 
        WHEN overall_pick BETWEEN 0 AND 10 THEN 'Top 10 picks'
        WHEN overall_pick BETWEEN 11 AND 25 THEN 'Picks 11-25'
        WHEN overall_pick BETWEEN 26 AND 60 THEN 'Picks 26-60'
        ELSE 'Picks 61 and above'
    END
ORDER BY 
    pick_group;


  
