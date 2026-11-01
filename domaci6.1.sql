CREATE SCHEMA IF NOT EXISTS bootcamp.sandbox;

USE bootcamp.sandbox;

CREATE OR REPLACE TABLE bootcamp.sandbox.matches_flat_copy AS
SELECT *
FROM bootcamp.northern_star.matches_flat;


--DOMACI 6.1

--ZADATAK 1: Kreiranje dimenzije igrača Na osnovu tabele players napravite tabelu dim_player koja sadrži sledeće kolone: player_id, ime, prezime, poziciju i nacionalnost igrača. Koliko redova ima novokreirana tabela?
--681

CREATE OR REPLACE TABLE bootcamp.sandbox.dim_player AS
SELECT player_id, first_name, last_name, position,nationality
FROM bootcamp.northern_star.players;

SELECT COUNT(*) AS broj_redova
FROM bootcamp.sandbox.dim_player;

--ZADATAK 2: 2. Kreiranje dimenzije datuma i činjenične tabele Napravite tabelu dim_date na isti način kao na predavanju. Zatim napravite tabelu fact_player_match na osnovu tabela player_match_stats i matches. Tabela treba da sadrži sledeće kolone: match_id, date_key, player_id, team_id,minutes_played, shots, passes i rating.U tabelu uključite samo podatke koji se odnose na odigrane utakmice.
--Kolika je granularnost tabele fact_player_match, odnosno šta predstavlja jedan njen red? 
--Jedan red predstavlja statistiku jednog igraca na jednoj utakmici
--Koliko redova ima ova tabela?
--30400
CREATE OR REPLACE TABLE bootcamp.sandbox.dim_date AS
SELECT CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
       d                                       AS full_date,
       DATE_FORMAT(d, 'EEEE')                  AS weekday_name,
       DAYOFWEEK(d) IN (1, 7)                  AS is_weekend,
       CASE WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
            ELSE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2))
       END                                     AS season
FROM (SELECT EXPLODE(SEQUENCE(DATE'2023-07-01', DATE'2025-06-30', INTERVAL 1 DAY)) AS d);

CREATE OR REPLACE TABLE bootcamp.sandbox.fact_player_match AS
SELECT pms.match_id, dd.date_key, pms.player_id,  pms.team_id, pms.minutes_played,pms.shots, pms.passes, pms.rating
FROM bootcamp.northern_star.player_match_stats pms
JOIN bootcamp.northern_star.matches m ON pms.match_id = m.match_id
JOIN bootcamp.sandbox.dim_date dd ON CAST(m.kickoff_ts AS DATE) = dd.full_date
WHERE m.status = 'played';


SELECT COUNT(*) AS broj_redova
FROM bootcamp.sandbox.fact_player_match;

--ZADATAK 3: 3. Prosečna ocena igrača po poziciji Koristeći napravljene dimenzije i činjeničnu tabelu, izračunajte prosečnu ocenu (rating) igrača za svaku poziciju tokom sezone 2024/25. Prikažite poziciju i odgovarajuću prosečnu ocenu.

SELECT dp.position,
 AVG(CAST(fpm.rating AS DOUBLE)) AS average_rating
FROM bootcamp.sandbox.fact_player_match fpm
JOIN bootcamp.sandbox.dim_player dp ON fpm.player_id = dp.player_id
JOIN bootcamp.sandbox.dim_date dd ON fpm.date_key = dd.date_key
WHERE dd.season = '2024/25' AND LOWER(TRIM(fpm.rating)) <> 'nan'
GROUP BY dp.position;


--ZADATAK 4: 4. Dodavanje broja golova u činjeničnu tabeli. Proširite tabelu fact_player_match dodavanjem kolone koja predstavlja broj golova koje je svaki igrač postigao na određenoj utakmici. Koliki je ukupan zbir golova svih igrača u tabeli fact_player_match?
--2043

ALTER TABLE bootcamp.sandbox.fact_player_match
ADD COLUMNS (goals BIGINT);
CREATE OR REPLACE TABLE bootcamp.sandbox.player_goals AS
SELECT match_id, player_id, COUNT(*) AS goals
FROM bootcamp.northern_star.match_events
WHERE event_type IN ('goal', 'penalty_goal')
GROUP BY match_id, player_id;


MERGE INTO bootcamp.sandbox.fact_player_match AS f
USING bootcamp.sandbox.player_goals AS g
ON f.match_id = g.match_id
AND f.player_id = g.player_id
WHEN MATCHED THEN
UPDATE SET f.goals = g.goals;

--ZADATAK 4: 4. Dodavanje broja golova u činjeničnu tabeli. Proširite tabelu fact_player_match dodavanjem kolone koja predstavlja broj golova koje je svaki igrač postigao na određenoj utakmici. Koliki je ukupan zbir golova svih igrača u tabeli fact_player_match?
--2043

ALTER TABLE bootcamp.sandbox.fact_player_match
ADD COLUMNS (goals BIGINT);
CREATE OR REPLACE TABLE bootcamp.sandbox.player_goals AS
SELECT match_id, player_id, COUNT(*) AS goals
FROM bootcamp.northern_star.match_events
WHERE event_type IN ('goal', 'penalty_goal')
GROUP BY match_id, player_id;


MERGE INTO bootcamp.sandbox.fact_player_match AS f
USING bootcamp.sandbox.player_goals AS g
ON f.match_id = g.match_id
AND f.player_id = g.player_id
WHEN MATCHED THEN
UPDATE SET f.goals = g.goals;

UPDATE bootcamp.sandbox.fact_player_match
SET goals = 0
WHERE goals IS NULL;

SELECT SUM(goals) AS ukupno_golova
FROM bootcamp.sandbox.fact_player_match;
