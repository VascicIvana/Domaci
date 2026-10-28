--DOMACI 5.2


--1. Prosek datih golova u poslednjih 5 utakmica, uz izričit okvir prozora. Koja je najveća vrednost? Računajte samo kada prozor zaista ima 5 utakmica.

WITH avg_goals AS (
    select season, team_id, match_id, kickoff_ts, goals_for,
    AVG(goals_for) OVER (PARTITION BY season, team_id ORDER BY kickoff_ts, match_id ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) as avg_goals_for,
    COUNT(*) OVER (PARTITION BY season, team_id ORDER BY kickoff_ts, match_id ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
) AS match_count
    FROM team_matches
    WHERE season = '2024/25'
)

SELECT MAX(avg_goals_for) AS max_avg_goals
FROM avg_goals
WHERE match_count = 5;


--2. Tekući zbir datih golova svakog kluba u sezoni 2024/25: ko je prvi stigao do 50 golova i kada?
WITH golovi AS(
select season, team_id, match_id, kickoff_ts, goals_for,
SUM(goals_for) OVER 
(PARTITION BY season, team_id ORDER BY kickoff_ts, match_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS goals
from team_matches
where season = '2024/25'
),
prvi_sa_50 AS(
SELECT season, team_id, match_id, kickoff_ts, goals_for,goals,
ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY kickoff_ts, match_id) AS rn
FROM golovi
WHERE goals >= 50
)

SELECT team_id, season, kickoff_ts, goals
FROM prvi_sa_50
WHERE rn = 1
ORDER BY kickoff_ts, match_id
LIMIT 1;



--3. Za svaku domaću utakmicu izračunajte promenu posećenosti u odnosu na prethodnu domaću utakmicu istog kluba u istoj sezoni. Gde je najveći pad i zašto?

--ne znam zasto

WITH home_matches AS (
select  season, match_id,  kickoff_ts,  home_team_id,attendance,
LAG(attendance) OVER (PARTITION BY season, home_team_id
            ORDER BY kickoff_ts, match_id) AS previous_attendance
from matches
where season = '2024/25'
)
SELECT season, home_team_id, match_id,kickoff_ts, attendance, previous_attendance,
    attendance - previous_attendance AS attendance_change
FROM home_matches
WHERE previous_attendance IS NOT NULL AND attendance IS NOT NULL
ORDER BY attendance_change ASC
LIMIT 1;