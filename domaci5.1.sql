--DOMACI 5.1

--1. Za sezonu 2024/25 prikažite igrače i ukupan broj golova koje su postigli. Prikažite samo igrače koji su postigli bar jedan gol. Pomoću DENSE_RANK() rangirajte igrače prema ukupnom brojugolova, od najvećeg ka najmanjem. Igrači sa istim brojem golova treba da imaju isti rang.

WITH player_goals 
AS (SELECT p.player_id, p.first_name, p.last_name, count (*) as total_goals
FROM match_events me
JOIN players p ON me.player_id = p.player_id
JOIN matches m ON me.match_id = m.match_id
WHERE season = '2024/25' and event_type IN('goal' ,'penalty_goal')
GROUP BY p.player_id,p.first_name, p.last_name
)

SELECT player_id, first_name, last_name, total_goals,
DENSE_RANK() OVER (ORDER BY total_goals DESC) AS goal_rank
FROM player_goals;


--2. Za sezonu 2024/25 prikažite tri igrača sa najviše postignutih golova za svaki klub. Prikažite naziv kluba, ime i prezime igrača i broj postignutih golova. Pomoću ROW_NUMBER() odredite redosled igračaunutar svakog kluba, od najvećeg ka najmanjem broju golova.

WITH player_goals AS
(select  me.player_id, p.first_name,p.last_name, count(*) as total_goals, me.team_id, t.team_name
from match_events me
join players p on p.player_id = me.player_id
join matches m on m.match_id = me.match_id
join teams t on t.team_id = me.team_id
where m.season = '2024/25' and me.event_type in ('goal', 'penalty_goal')
GROUP BY me.team_id, t.team_name, me.player_id, p.first_name,p.last_name
)

SELECT first_name, last_name, total_goals, team_name,
ROW_NUMBER() OVER (PARTITION BY team_name ORDER BY total_goals DESC) AS rang
FROM player_goals
QUALIFY rang <= 3;

--3. Za sezonu 2024/25 prikažite sve utakmice svakog kluba, broj golova koje je klub postigao i broj golova koje je postigao u svojoj prethodnoj utakmici. Pomoću LAG() pronađite broj golova iz prethodne utakmiceIzračunajte i razliku između broja golova na tekućoj i prethodnoj utakmici. Rezultate sortirajte po nazivu kluba i datumu utakmice.

WITH club_matches AS (
    select t.team_name, tm.season, tm.kickoff_ts, tm.goals_for,t.team_id
from team_matches tm
join teams t on t.team_id = tm.team_id
where season = '2024/25'
)

SELECT team_name,team_id, kickoff_ts, goals_for,
LAG(goals_for)OVER(PARTITION BY team_id ORDER BY kickoff_ts) AS previous_goals,
goals_for - LAG(goals_for)OVER(PARTITION BY team_id ORDER BY kickoff_ts) AS goals_difference
FROM club_matches
ORDER BY team_name, kickoff_ts;
