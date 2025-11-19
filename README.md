================================================================================
PROJECT TITLE: Golden State Warriors 2015-16 Season Analysis
================================================================================

--------------------------------------------------------------------------------
1. PROJECT OVERVIEW
--------------------------------------------------------------------------------
This project analyzes the historic 2015-2016 NBA season of the Golden State 
Warriors, a team that set the league record with 73 wins and only 9 losses. 

The goal was to simulate a request from a coaching staff or front office 
requiring a detailed performance report. Specifically, the stakeholder needed 
to identify "high-performance" games—nights where the team scored above their 
own seasonal average—and benchmark those performances against league-wide 
trends on those specific dates.

--------------------------------------------------------------------------------
2. BUSINESS PROBLEM & OBJECTIVE
--------------------------------------------------------------------------------
Raw sports data is often fragmented. Scores are separated into "Home" and 
"Away" columns, making it difficult to track a single team's performance 
chronologically. 

The objective of this SQL analysis was to:
1. Standardize raw game data into a readable, team-centric format.
2. Calculate key performance metrics (margin of victory, running win totals).
3. Provide context by comparing team scoring against the league average 
   for that specific date.
4. Filter the final output to highlight only exceptional offensive performances.

--------------------------------------------------------------------------------
3. TECHNICAL SKILLS DEMONSTRATED
--------------------------------------------------------------------------------
This project utilizes advanced SQL techniques to transform raw relational data 
into an analytical dataset:

* Common Table Expressions (CTEs): Used to clean and normalize raw data 
  before analysis, handling complex "Home vs. Away" logic.
* Window Functions: Used to calculate cumulative metrics (Running Total of Wins) 
  without collapsing rows.
* Correlated Subqueries: Used to calculate dynamic benchmarks (League Average 
  Score) specific to each game's date.
* Subqueries in WHERE Clause: Used to filter the final dataset dynamically 
  based on the team's season-long average.
* CASE Statements: Used to create categorical data ("Blowout Win", "Close Win") 
  from numerical scores.
* JOINS: Used to enrich game data with readable team names (Nicknames) from 
  lookup tables.

--------------------------------------------------------------------------------
4. DATA SOURCE
--------------------------------------------------------------------------------
The analysis uses a relational database consisting of two primary tables:
1. `game`: Historical game data including season IDs, dates, and scores.
2. `team`: Lookup table containing team IDs, full names, and nicknames.

*Data Scope:* Filtered specifically for Season ID 22015 (The 2015-2016 NBA Season).

--------------------------------------------------------------------------------
5. STEPS TO REPRODUCE
--------------------------------------------------------------------------------
1. Import the provided `game.csv` and `team.csv` files into your SQL environment 
   (PostgreSQL, SQLite, MySQL, etc.).
2. Run the SQL script provided in this repository (`Warriors_2015-16_Season.sql`).
3. The output will generate a chronological report of the Warriors' best 
   offensive games.

--------------------------------------------------------------------------------
6. SAMPLE INSIGHTS
--------------------------------------------------------------------------------
The query output allows stakeholders to answer questions such as:
* "How often did the team blow out opponents by 15+ points?"
* "On nights where we scored high, was the rest of the league also scoring high?"
* "What was our win streak momentum during high-scoring stretches?"

================================================================================
Thank you for reviewing this project!
================================================================================
