-- Vežba 2: dosije kluba - Kingsbridge City, sezona 2024/25

-- 1. Sezona u brojevima
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
),
strane AS (                                       
  SELECT season, home_team_id AS team_id, home_goals AS dati, away_goals AS primljeni
  FROM matches WHERE status = 'played'
  UNION ALL
  SELECT season, away_team_id, away_goals, home_goals
  FROM matches WHERE status = 'played'
)
SELECT COUNT(*)                                                    AS utakmice,
       COUNT_IF(dati > primljeni)                                  AS pobede,
       COUNT_IF(dati = primljeni)                                  AS nereseno,
       COUNT_IF(dati < primljeni)                                  AS porazi,
       SUM(dati)                                                   AS dati_golovi,
       SUM(primljeni)                                              AS primljeni_golovi,
       SUM(CASE WHEN dati > primljeni THEN 3
                WHEN dati = primljeni THEN 1 ELSE 0 END)           AS bodovi
FROM strane s
JOIN club c ON s.team_id = c.team_id
WHERE s.season = '2024/25';


-- 2. Kod kuće i u gostima
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
),
strane AS (
  SELECT season, home_team_id AS team_id, 'domaćin' AS teren,
         home_goals AS dati, away_goals AS primljeni
  FROM matches WHERE status = 'played'
  UNION ALL
  SELECT season, away_team_id, 'gost', away_goals, home_goals
  FROM matches WHERE status = 'played'
)
SELECT s.teren,
       COUNT(*)                                                    AS utakmice,
       COUNT_IF(dati > primljeni)                                  AS pobede,
       COUNT_IF(dati = primljeni)                                  AS nereseno,
       COUNT_IF(dati < primljeni)                                  AS porazi,
       SUM(dati)                                                   AS dati_golovi,
       SUM(primljeni)                                              AS primljeni_golovi,
       SUM(CASE WHEN dati > primljeni THEN 3
                WHEN dati = primljeni THEN 1 ELSE 0 END)           AS bodovi
FROM strane s
JOIN club c ON s.team_id = c.team_id
WHERE s.season = '2024/25'
GROUP BY s.teren;
 

 -- 3. Strelci: tri najbolja strelca i najbolji asistent
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
),
golovi_kluba AS (
  SELECT e.player_id, e.related_player_id          -- related_player_id je asistent
  FROM match_events e
  JOIN matches m ON e.match_id = m.match_id
  JOIN club c    ON e.team_id  = c.team_id
  WHERE m.season = '2024/25'
    AND e.event_type IN ('goal', 'penalty_goal')   -- autogolovi se ne računaju
),
strelci AS (
  SELECT player_id, COUNT(*) AS broj
  FROM golovi_kluba
  GROUP BY player_id
  ORDER BY broj DESC, player_id
  LIMIT 3
),
asistenti AS (
  SELECT related_player_id AS player_id, COUNT(*) AS broj
  FROM golovi_kluba
  WHERE related_player_id IS NOT NULL
  GROUP BY related_player_id
  ORDER BY broj DESC, player_id
  LIMIT 1
)
SELECT 'strelac' AS uloga,
       COALESCE(NULLIF(p.known_as, ''), CONCAT(p.first_name, ' ', p.last_name)) AS igrac,
       s.broj
FROM strelci s JOIN players p ON s.player_id = p.player_id
UNION ALL
SELECT 'asistent',
       COALESCE(NULLIF(p.known_as, ''), CONCAT(p.first_name, ' ', p.last_name)),
       a.broj
FROM asistenti a JOIN players p ON a.player_id = p.player_id;
 

 -- 4. Disciplina: kartoni po utakmici, klub u poređenju sa prosekom lige po timu po utakmici
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
),
odigrane AS (                                      -- jedan red po timu
  SELECT team_id, COUNT(*) AS broj_utakmica
  FROM (SELECT home_team_id AS team_id FROM matches WHERE status = 'played' AND season = '2024/25'
        UNION ALL
        SELECT away_team_id FROM matches WHERE status = 'played' AND season = '2024/25')
  GROUP BY team_id
),
kartoni AS (                                       -- jedan red po timu
  SELECT e.team_id,
         COUNT_IF(e.event_type = 'yellow_card')                  AS zuti,
         COUNT_IF(e.event_type IN ('red_card', 'second_yellow')) AS crveni
  FROM match_events e
  JOIN matches m ON e.match_id = m.match_id
  WHERE m.season = '2024/25' AND m.status = 'played'
  GROUP BY e.team_id
),
po_timu AS (
  SELECT o.team_id, o.broj_utakmica,
         COALESCE(k.zuti, 0)    AS zuti,
         COALESCE(k.crveni, 0)  AS crveni
  FROM odigrane o
  LEFT JOIN kartoni k ON o.team_id = k.team_id
)
SELECT 'klub' AS grupa,
       ROUND(SUM(zuti)    / SUM(broj_utakmica), 2) AS zuti_po_utakmici,
       ROUND(SUM(crveni)  / SUM(broj_utakmica), 2) AS crveni_po_utakmici
FROM po_timu
WHERE team_id IN (SELECT team_id FROM club)
UNION ALL
SELECT 'prosek lige',
       ROUND(SUM(zuti)    / SUM(broj_utakmica), 2),
       ROUND(SUM(crveni)  / SUM(broj_utakmica), 2)
FROM po_timu;
 

 -- 5. Treneri: ko je vodio klub i sa koliko bodova po utakmici (spajanje po opsegu)
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
),
strane AS (
  SELECT season, kickoff_ts, home_team_id AS team_id,
         CASE WHEN home_goals > away_goals THEN 3 WHEN home_goals = away_goals THEN 1 ELSE 0 END AS bodovi
  FROM matches WHERE status = 'played'
  UNION ALL
  SELECT season, kickoff_ts, away_team_id,
         CASE WHEN away_goals > home_goals THEN 3 WHEN away_goals = home_goals THEN 1 ELSE 0 END
  FROM matches WHERE status = 'played'
)
SELECT ms.manager_name, ms.is_caretaker,
       COUNT(*)                  AS utakmice,
       SUM(s.bodovi)             AS bodovi,
       ROUND(AVG(s.bodovi), 2)   AS bodovi_po_utakmici
FROM strane s
JOIN club c ON s.team_id = c.team_id
JOIN manager_spells ms
  ON ms.team_id = s.team_id
 AND DATE(s.kickoff_ts) BETWEEN ms.start_date
                            AND COALESCE(ms.end_date, DATE'9999-12-31')
WHERE s.season = '2024/25'
GROUP BY ms.manager_name, ms.is_caretaker
ORDER BY utakmice DESC;

-- 6. Najveća pobeda i najteži poraz
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
),
utakmice_kluba AS (
  SELECT DATE(m.kickoff_ts) AS datum,
         CASE WHEN m.home_team_id = c.team_id THEN 'domaćin' ELSE 'gost' END AS teren,
         o.team_name AS protivnik,
         CASE WHEN m.home_team_id = c.team_id THEN m.home_goals ELSE m.away_goals END AS dati,
         CASE WHEN m.home_team_id = c.team_id THEN m.away_goals ELSE m.home_goals END AS primljeni,
         CASE WHEN m.home_team_id = c.team_id THEN m.home_goals - m.away_goals
              ELSE m.away_goals - m.home_goals END AS razlika
  FROM matches m
  JOIN club c  ON c.team_id IN (m.home_team_id, m.away_team_id)
  JOIN teams o ON o.team_id = CASE WHEN m.home_team_id = c.team_id THEN m.away_team_id ELSE m.home_team_id END
  WHERE m.season = '2024/25' AND m.status = 'played'
)
SELECT * FROM (SELECT 'najveća pobeda' AS tip, * FROM utakmice_kluba ORDER BY razlika DESC LIMIT 1)
UNION ALL
SELECT * FROM (SELECT 'najteži poraz', * FROM utakmice_kluba ORDER BY razlika ASC LIMIT 1);


-- 7. Publika: prosečna poseta, popunjenost i utakmice bez podatka o poseti
WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'Kingsbridge City'
)
SELECT ROUND(AVG(m.attendance))                 AS prosecna_poseta,
       ROUND(AVG(m.attendance / s.capacity), 3) AS popunjenost,
       COUNT_IF(m.attendance IS NULL)           AS utakmice_bez_podatka_o_poseti
FROM matches m
JOIN club c     ON m.home_team_id = c.team_id
JOIN stadiums s ON m.stadium_id   = s.stadium_id
WHERE m.season = '2024/25' AND m.status = 'played';
