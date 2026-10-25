--DOMACI 4.1

--ZADATAK 1: Koliko redova ima spoj matches i player_match_stats za sezonu 2024/25? Objasnite

--Dobija se 15200 redova zato sto vise igraca iz player_match_stats ima isti match_id jer su igrali istu utakmicu. Isti rezultat se dobija i sa LEFT JOIN, sto znaci da nema NULL vrednosti i svaki red ima poklapanje u drugoj tabeli

SELECT COUNT(*)
FROM matches AS m
JOIN player_match_stats AS pms
ON pms.match_id = m.match_id 
WHERE season = '2024/25';

--ZADATAK 2: Koliko puta je igrač u istoj sezoni igrao za dva različita kluba?

SELECT COUNT(*)
FROM (
    SELECT
        pms.player_id,
        m.season
    FROM player_match_stats pms
    JOIN matches m
        ON pms.match_id = m.match_id
    GROUP BY pms.player_id, m.season
    HAVING COUNT(DISTINCT pms.team_id) > 1
) AS player_seasons;


--ZADATAK 3: Koliko utakmica ima više kartona od prosečne utakmice? Bez kartona računajte sa 0.

WITH cards_per_match AS (
    SELECT
        m.match_id,
        COUNT(e.event_id) AS card_count
    FROM matches m
    LEFT JOIN match_events e
        ON m.match_id = e.match_id
        AND e.event_type IN ('yellow_card', 'second_yellow', 'red_card')
    GROUP BY m.match_id
)
SELECT COUNT(*)
FROM cards_per_match
WHERE card_count > (
    SELECT AVG(card_count)
    FROM cards_per_match
);


--ZADATAK 4: Koliko igrača je odigralo više od 10 utakmica u sezoni 2024/25?

SELECT COUNT(*)
FROM (
    SELECT pms.player_id
    FROM player_match_stats pms
    JOIN matches m
        ON pms.match_id = m.match_id
    WHERE m.season = '2024/25'
    GROUP BY pms.player_id
    HAVING COUNT(DISTINCT pms.match_id) > 10
) AS players_over_10;


--ZADATAK 5: Prikažite sve klubove koji su igrali u sezoni 2024/25, bilo kao domaćini ili kao gosti. Koristite UNION, a zatim izmenite upit tako da koristi UNION ALL. Objasnite razliku u broju redova koji dobijate.

--UNION UKLANJA DUPLIKATE DOK IH UNION ALL ZADRZAVA

--UNION

WITH clubs AS (
    SELECT home_team_id AS team_id
    FROM matches
    WHERE season = '2024/25'

    UNION

    SELECT away_team_id AS team_id
    FROM matches
    WHERE season = '2024/25'
)
SELECT t.team_name
FROM clubs c
JOIN teams t
    ON c.team_id = t.team_id;

--UNION ALL

WITH clubs AS (
    SELECT home_team_id AS team_id
    FROM matches
    WHERE season = '2024/25'

    UNION ALL

    SELECT away_team_id AS team_id
    FROM matches
    WHERE season = '2024/25'
)
SELECT t.team_name
FROM clubs c
JOIN teams t
    ON c.team_id = t.team_id;