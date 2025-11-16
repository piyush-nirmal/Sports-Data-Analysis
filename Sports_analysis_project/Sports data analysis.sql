DROP DATABASE IF EXISTS sports;
CREATE DATABASE sports;
USE sports;
-- Table definitions with ON DELETE CASCADE for better data management
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);
CREATE TABLE Games (
    game_id INT PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    score_team1 INT,
    score_team2 INT,
    game_date DATE,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id)
);
-- IMPROVEMENT: Added ON DELETE CASCADE to automatically delete player stats when a game is deleted.
CREATE TABLE PlayerStats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT,
    game_id INT,
    points INT,
    assists INT,
    rebounds INT,
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE
);

-- Data Insertion (same as before)
INSERT INTO Teams (team_id, team_name) VALUES
(1, 'Red Dragons'), (2, 'Blue Tigers'), (3, 'Green Sharks'), (4, 'Yellow Eagles'),
(5, 'Black Panthers'), (6, 'White Wolves'), (7, 'Orange Bears'), (8, 'Purple Lions'),
(9, 'Silver Falcons'), (10, 'Gold Hawks'), (11, 'Crimson Hawks'), (12, 'Azure Foxes'),
(13, 'Emerald Snakes'), (14, 'Amber Owls'), (15, 'Ivory Elephants'), (16, 'Navy Dolphins'),
(17, 'Bronze Rhinos'), (18, 'Violet Lynxes'), (19, 'Steel Bulls'), (20, 'Titan Bears');
INSERT INTO Players (player_id, player_name, team_id) VALUES
(1, 'John Doe', 1), (2, 'Jane Smith', 2), (3, 'Michael Brown', 3), (4, 'Emily Davis', 4),
(5, 'David Wilson', 5), (6, 'Sarah Moore', 6), (7, 'James Taylor', 7), (8, 'Linda Anderson', 8),
(9, 'Robert Lee', 9), (10, 'Maria Martinez', 10), (11, 'Chris Evans', 11), (12, 'Scarlett Johnson', 12),
(13, 'Mark Ruffalo', 13), (14, 'Jeremy Renner', 14), (15, 'Tom Holland', 15), (16, 'Benedict Cumberbatch', 16),
(17, 'Chadwick Boseman', 17), (18, 'Elizabeth Olsen', 18), (19, 'Paul Rudd', 19), (20, 'Tom Hardy', 20),
(21, 'Free Agent Player', NULL);
INSERT INTO Games (game_id, team1_id, team2_id, score_team1, score_team2, game_date) VALUES
(1, 1, 2, 5, 3, '2025-08-01'), (2, 3, 4, 2, 4, '2025-08-02'), (3, 5, 6, 6, 6, '2025-08-03'),
(4, 7, 8, 3, 3, '2025-08-04'), (5, 9, 10, 7, 1, '2025-08-05'), (6, 1, 3, 4, 2, '2025-08-15'),
(7, 2, 4, 5, 5, '2025-08-16'), (8, 6, 7, 6, 2, '2025-08-17'), (9, 8, 9, 4, 6, '2025-08-18'),
(10, 5, 10, 7, 3, '2025-08-19'), (11, 11, 12, 3, 5, '2025-08-20'), (12, 13, 14, 4, 4, '2025-08-21'),
(13, 15, 16, 7, 6, '2025-08-22'), (14, 17, 18, 5, 8, '2025-08-23'), (15, 19, 20, 9, 2, '2025-08-24'),
(16, 11, 13, 6, 5, '2025-08-25'), (17, 12, 14, 7, 4, '2025-08-26'), (18, 15, 17, 5, 6, '2025-08-27'),
(19, 16, 18, 8, 7, '2025-08-28'), (20, 19, 11, 4, 3, '2025-08-29');
INSERT INTO PlayerStats (player_id, game_id, points, assists, rebounds) VALUES
(1, 1, 5, 3, 8), (2, 1, 3, 5, 4), (3, 2, 2, 1, 2), (4, 2, 4, 3, 5), (5, 3, 6, 4, 7),
(6, 3, 6, 5, 6), (7, 4, 3, 2, 4), (8, 4, 3, 3, 3), (9, 5, 7, 1, 9), (10, 5, 1, 1, 2),
(11, 11, 3, 2, 5), (12, 11, 5, 4, 6), (13, 12, 4, 3, 3), (14, 12, 4, 5, 4), (15, 13, 7, 2, 8),
(16, 13, 6, 4, 7), (17, 14, 5, 1, 5), (18, 14, 8, 3, 9), (19, 15, 9, 2, 11), (20, 15, 2, 1, 3);

### 1. Query to calculate the total points scored by each player
use sports;
SELECT
    p.player_name,
    COALESCE(SUM(ps.points), 0) AS total_points
FROM Players p
LEFT JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_name
ORDER BY total_points DESC;

### 2. Query to find players who scored points between 3 and 6

SELECT
    p.player_name,
    ps.game_id,
    ps.points
FROM Players p
JOIN PlayerStats ps ON p.player_id = ps.player_id
WHERE ps.points BETWEEN 3 AND 6
ORDER BY p.player_name, ps.points;


### 3. Find players from the same team
use sports;
SELECT
    t.team_name,
    p1.player_name AS player1,
    p2.player_name AS player2
FROM Players p1
JOIN Players p2 ON p1.team_id = p2.team_id 
AND p1.player_id < p2.player_id
JOIN Teams t ON p1.team_id = t.team_id
ORDER BY t.team_name, p1.player_name, p2.player_name;

### 4. Find games played in the last 30 days
use sports;
SELECT
    game_id,
    t1.team_name AS team1,
    t2.team_name AS team2,
    score_team1,
    score_team2,
    game_date
FROM Games g
JOIN Teams t1 ON g.team1_id = t1.team_id
JOIN Teams t2 ON g.team2_id = t2.team_id
WHERE game_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

### 5. Create a view to summarize player statistics
CREATE OR REPLACE VIEW PlayerStatisticsSummary AS
SELECT
    p.player_name,
    t.team_name,
    COUNT(ps.game_id) AS games_played,
    COALESCE(SUM(ps.points), 0) AS total_points,
    COALESCE(AVG(ps.points), 0) AS avg_points_per_game,
    COALESCE(SUM(ps.assists), 0) AS total_assists,
    COALESCE(SUM(ps.rebounds), 0) AS total_rebounds
FROM Players p
LEFT JOIN Teams t ON p.team_id = t.team_id
LEFT JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_id, p.player_name, t.team_name;
-- After creating the view, query it like this:
SELECT * FROM PlayerStatisticsSummary;

### 6. Create a trigger to ensure points cannot be negative

DELIMITER $$
CREATE TRIGGER before_playerstats_insert
BEFORE INSERT ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Points cannot be negative.';
    END IF;
END$$*
DELIMITER ;

-- To test it, run this. It will produce an error, proving the trigger works.
-- INSERT INTO PlayerStats (player_id, game_id, points, assists, rebounds) VALUES (1, 2, -5, 2, 3);

### 7. Fetch all players and their respective teams, including players without a team
SELECT
    p.player_name,
    t.team_name
FROM Players p
LEFT JOIN Teams t ON p.team_id = t.team_id;

### 8. Total points scored by players, grouped by their teams

SELECT
    t.team_name,
    SUM(ps.points) AS total_team_points
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
GROUP BY t.team_name
ORDER BY total_team_points DESC;

### 9. Players who scored more than 5 points
SELECT
    p.player_name,
    SUM(ps.points) as total_points
FROM Players p
JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_name
HAVING SUM(ps.points) > 5;

### 10. Update and assign Sarah Moore to the team Green Sharks|
set sql_safe_updates=0; -- Switching off the safe mode
UPDATE Players
SET team_id = (SELECT team_id FROM Teams 
WHERE team_name = 'Green Sharks')
WHERE player_name = 'Sarah Moore';
-- Verify the change:
SELECT p.player_name, t.team_name 
FROM Players p JOIN Teams t 
ON p.team_id = t.team_id 
WHERE p.player_name = 'Sarah Moore';

### 11. Deleting all records where the game id is 5
-- You must delete from the 'child' table (PlayerStats) first to satisfy the foreign key constraint.
DELETE FROM PlayerStats WHERE game_id = 5;
DELETE FROM Games WHERE game_id = 5;

-- Verify the deletion (this will return an empty set)
SELECT * FROM Games WHERE game_id = 5;

### 12. Players who scored more than the average points in a specific game
use sports;
SELECT
    p.player_name,
    ps.points
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
WHERE ps.game_id = 1
  AND ps.points > (SELECT AVG(points) 
  FROM PlayerStats WHERE game_id = 1);	
  
  ### 13. Find the top 3 players who have scored the highest total points across all games

SELECT
    p.player_name,
    SUM(ps.points) AS total_points
FROM Players p
JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_name
ORDER BY total_points DESC
LIMIT 3;

### 14. Retrieve a list of teams that have won at least one game
SELECT DISTINCT team_name 
FROM ( -- Find teams that won as 'team1' 
SELECT t.team_name  
FROM Games g JOIN Teams t ON g.team1_id = t.team_id  
WHERE g.score_team1 > g.score_team2 
UNION -- Find teams that won as 'team2' 
SELECT t.team_name  
FROM Games g JOIN Teams t ON g.team2_id = t.team_id  
WHERE g.score_team2 > g.score_team1 
) AS winning_teams 
ORDER BY team_name; 

-- List of teams that have won at least one game, with scores and opponent


### 15. Determine the average number of rebounds per player for each team
SELECT
    t.team_name,
    AVG(ps.rebounds) AS avg_rebounds_per_player_game
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
GROUP BY t.team_name
ORDER BY avg_rebounds_per_player_game DESC;

