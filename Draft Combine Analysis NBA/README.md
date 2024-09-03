# NBA Combine Stats SQL Project

## Introduction
This project analyzes NBA draft combine statistics to uncover insights about player performance and draft outcomes. The analysis includes correlation studies, grouping by draft pick ranges, and average performance metrics by player attributes.


## Data Sources
- **Draft Combine Stats (`draft_combine_stats.csv`)**: Contains various physical and performance metrics of players who participated in the NBA Draft Combine.
  - Key Columns: `height_cm`, `weight`, `wingspan`, `standing_vertical_leap`, `bench_press`, etc.
  
- **Draft History (`draft_history.csv`)**: Includes the draft history of players, such as `round_number`, `round_pick`, and `overall_pick`.
  - Key Columns: `round_number`, `round_pick`, `overall_pick`, etc.

Note: These Datasets where precleaned in Excel, with some final changes made on SQL Server before writing queries.

## Files
- **data_cleaning.sql**: Modified datatypes, and renamed id columns
- **sql_analysis.sql**: Answer questions below

## Analysis
1. How do physical attributes (height, weight, wingspan, vertical leap, etc.) correlate with draft position?
2. How have player physical characteristics evolved over different seasons? Are players getting taller, heavier, or more agile?
3. What are the typical physical attributes for different positions (e.g., guards vs. forwards vs. centers)?
4. Is there a correlation between body fat percentage and a player’s agility or sprint times?
5. Do players with longer wingspans and greater hand size perform better or worse in the bench press?
6. Can we predict a player’s draft success based on their combine stats?
