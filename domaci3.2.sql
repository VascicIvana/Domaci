--DOMACI 3.2 

--ZADATAK 1: Prikažite naziv svakog kluba i naziv stadiona na kojem igra domaće utakmice.

SELECT s.stadium_name, t.team_name
FROM stadiums s
JOIN teams t ON s.stadium_id = t.stadium_id;


--ZADATAK 2: 2.Prikažite ime i prezime igrača i naziv kluba za koji je igrao u sezoni 2024/25. Uklonite duplikate iz rezultata.


SELECT DISTINCT
    p.first_name,
    p.last_name,
    t.team_name,
    m.season 
FROM players p
JOIN player_match_stats pms
    ON p.player_id = pms.player_id
JOIN matches m
    ON m.match_id = pms.match_id
JOIN teams t
    ON t.team_id = pms.team_id
WHERE m.season = '2024/25';


--ZADATAK 3: Prikažite datum odigravanja utakmice, naziv stadiona i broj gledalaca za sve utakmice u sezoni 2024/25.

SELECT
    DATE(m.kickoff_ts) AS match_date,
    s.stadium_name,
    m.attendance
FROM matches m
JOIN stadiums s ON s.stadium_id = m.stadium_id
WHERE m.season = '2024/25';



--SREDNJI NIVO
--ZADATAK 1: 1.Prikažite sve utakmice za koje nije evidentiran broj gledalaca. Prikažite datum, domaći klub i gostujući  klub.

SELECT 
DATE(m.kickoff_ts) AS date,
t.team_name AS home_team,
tt.team_name AS away_team,
m.attendance

FROM matches m 
JOIN teams t ON t.team_id = m.home_team_id 
JOIN teams tt ON tt.team_id = m.away_team_id
WHERE m.attendance IS NULL;


--ZADATAK 2: 2.Pronađite stadione na kojima nije odigrana ni jedna utakmica u sezoni 2024/25.

SELECT
    s.stadium_name
FROM stadiums s
LEFT JOIN matches m ON s.stadium_id = m.stadium_id
     AND m.season = '2024/25'
WHERE m.match_id IS NULL;

--ZADATAK 3: 3.Za svaki klub izračunajte ukupan broj žutih kartona koje su dobili njegovi igrači u sezoni 2024/25. Rezultat sortirajte opadajuće prema broju kartona.

SELECT COUNT(*) AS ukupan_broj_zutih,
       t.team_name
FROM match_events e
JOIN matches m
    ON e.match_id = m.match_id
JOIN teams t
    ON e.team_id = t.team_id
WHERE m.season = '2024/25'
    AND e.event_type IN ('yellow_card', 'second_yellow')
GROUP BY t.team_name
ORDER BY ukupan_broj_zutih DESC;

--NAPREDNI NIVO
--ZADATAK 1: Pronađite pet igrača sa najvećim brojem asistencija u sezoni 2024/25. Prikažite ime igrača i broj asistencija.

SELECT
    p.first_name,
    p.last_name,
    COUNT(*) AS assists
FROM match_events e
JOIN players p
    ON e.related_player_id = p.player_id
JOIN matches m
    ON e.match_id = m.match_id
WHERE e.event_type = 'goal'
    AND m.season = '2024/25'
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY assists DESC
LIMIT 5;

--ZADATAK 2: 2.Pronađite tri igrača sa najvećim ukupnim brojem odigranih minuta u sezoni 2024/25. Prikažite ime igrača, klub i ukupan broj minuta.

SELECT
    p.first_name,
    p.last_name,
    t.team_name,
    SUM(pms.minutes_played) AS total_minutes
FROM player_match_stats pms
JOIN players p
    ON pms.player_id = p.player_id
JOIN teams t
    ON pms.team_id = t.team_id
JOIN matches m
    ON pms.match_id = m.match_id
WHERE m.season = '2024/25'
GROUP BY p.player_id, p.first_name, p.last_name, t.team_name
ORDER BY total_minutes DESC
LIMIT 3;


--ZADATAK 3: Za svaku sezonu prikažite broj isključenja po klubovima. Računajte događaje red_card i second_yellow. Uključitesamo klubove koji su imali najmanje jedno isključenje.

SELECT
    m.season,
    t.team_name,
    COUNT(*) AS dismissals
FROM match_events e
JOIN matches m
    ON e.match_id = m.match_id
JOIN teams t
    ON e.team_id = t.team_id
WHERE e.event_type IN ('red_card', 'second_yellow')
GROUP BY m.season, t.team_name
ORDER BY m.season, dismissals DESC;
