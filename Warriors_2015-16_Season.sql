/* PORTFOLIO PROJECT: Golden State Warriors 2015-16 Season Analysis
   GOAL: Analyze high-performance games from the Warriors' historic 73-9 season.
   
   This query generates a report of games where the team scored above their seasonal average.
   It includes opponent details, performance categories, a running win count, and 
   benchmarks against the league average for that day.
*/

-- STEP 1: Create a temporary "Master List" (Common Table Expression) 
-- This organizes the raw data into a clean format for the Golden State Warriors (ID: 1610612744)
-- for the 2015-2016 Season (ID: 22015).
WITH warriors_2015 AS (
    SELECT 
        g.game_date,
        g.game_id,
        
        -- Normalize Points: Since the Warriors play both 'Home' and 'Away', 
        -- we check which side they are on to ensure 'warriors_pts' always holds their score.
        CASE WHEN g.team_id_home = 1610612744 THEN g.pts_home 
             ELSE g.pts_away END AS warriors_pts,
             
        -- Normalize Opponent Points: Similarly, grab the score of the opposing team.
        CASE WHEN g.team_id_home = 1610612744 THEN g.pts_away 
             ELSE g.pts_home END AS opponent_pts,
             
        -- Identify Opponent: Grab the nickname of the team playing AGAINST the Warriors.
        CASE WHEN g.team_id_home = 1610612744 THEN t_away.nickname 
             ELSE t_home.nickname END AS opponent,
             
        -- Create Win Indicator: Assign a '1' if Warriors scored more than the opponent (Win),
        -- otherwise '0' (Loss). This allows us to sum up wins mathematically later.
        CASE WHEN (g.team_id_home = 1610612744 AND g.pts_home > g.pts_away) OR
                  (g.team_id_away = 1610612744 AND g.pts_away > g.pts_home) 
             THEN 1 ELSE 0 END AS win_flag
             
    FROM game AS g
    -- Join with the team table twice to get names for both Home and Away teams
    LEFT JOIN team AS t_home ON g.team_id_home = t_home.id
    LEFT JOIN team AS t_away ON g.team_id_away = t_away.id
    
    -- Filter specifically for the 2015-16 season and games involving the Warriors
    WHERE g.season_id = 22015 
      AND (g.team_id_home = 1610612744 OR g.team_id_away = 1610612744)
)

-- STEP 2: Generate the Final Analytical Report
-- We select data from our clean "Master List" (warriors_2015) created above.
SELECT 
    w.game_date,
    w.opponent,
    w.warriors_pts,
    w.opponent_pts,
    -- Calculate the margin of victory (or defeat)
    (w.warriors_pts - w.opponent_pts) AS point_diff,
    
    -- Categorize Performance: Create readable labels for the result based on point difference.
    -- "Blowout Win" = Winning by more than 15 points.
    -- "Close Win" = Winning by 1-15 points.
    CASE WHEN (w.warriors_pts - w.opponent_pts) > 15 THEN 'Blowout Win'
         WHEN (w.warriors_pts - w.opponent_pts) > 0 THEN 'Close Win'
         ELSE 'Loss' END AS performance_label,

    -- Track Season Momentum: Use a "Window Function" to calculate a running total of wins.
    -- This shows how many wins the team had accumulated up to that specific date.
    SUM(w.win_flag) OVER(ORDER BY w.game_date 
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_wins,

    -- Benchmark Performance: Calculate the average score of ALL NBA teams playing on this specific date.
    -- This helps visualize if the Warriors' high score was due to league-wide trends or specific team skill.
    (SELECT ROUND(AVG(pts_home + pts_away) / 2, 1)
     FROM game 
     WHERE game_date = w.game_date) AS league_avg_pts_on_date

FROM warriors_2015 AS w

-- STEP 3: Filter for "High Performance" Nights
-- We only want to see games where the Warriors scored ABOVE their own average for the season.
WHERE w.warriors_pts > 
    (SELECT AVG(CASE WHEN team_id_home = 1610612744 THEN pts_home ELSE pts_away END)
     FROM game 
     WHERE season_id = 22015 
       AND (team_id_home = 1610612744 OR team_id_away = 1610612744))

-- Sort the report chronologically
ORDER BY w.game_date;
