
--Modify DataTypes for better visability
ALTER TABLE NBA_data.dbo.draft_combine_stats
ALTER COLUMN modified_lane_agility_time DECIMAL(10,2);

ALTER TABLE NBA_data.dbo.draft_combine_stats
ALTER COLUMN lane_agility_time DECIMAL(10,2);

ALTER TABLE NBA_data.dbo.draft_combine_stats
ALTER COLUMN three_quarter_sprint DECIMAL(10,2);

ALTER TABLE NBA_data.dbo.draft_combine_stats
ALTER COLUMN body_fat_pct DECIMAL(10,2);

--Rename player_id and person_id both to id in both tables
EXEC sp_rename 'draft_combine_stats.player_id', 'id', 'COLUMN';

EXEC sp_rename 'draft_history.person_id', 'id', 'COLUMN';


