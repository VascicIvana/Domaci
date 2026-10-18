-- Zadatak 1: Dodaj kolonu empty_seats (kapacitet stadiona minus poseta) i prikazi 5 utakmica sa najvise praznih mesta
-- Sta je zajednicko za prve tri? 
-- Zajednicno za prve tri je da su se odigrale na istom stadionu

SELECT stadium_capacity, attendance, stadium_capacity - attendance AS empty_seats, stadium_name
FROM bootcamp.domaci.matches_flat
ORDER BY  empty_seats DESC
LIMIT 5;



-- Zadatak 2: Koliko razlicitih sudija je sudilo domace utakmice kluba Riverton Athletics?
-- 15

SELECT DISTINCT referee_name 
FROM bootcamp.domaci.matches_flat
WHERE home_team = 'Riverton Athletic';

-- Zadatak 3: U koliko utakmica je gost vodio na poluvremenu, a domacin pobedio?
-- 15

SELECT home_goals, away_goals, home_goals_ht, away_goals_ht
FROM bootcamp.domaci.matches_flat
WHERE away_goals_ht > home_goals_ht
AND home_goals > away_goals;

-- Zadatak 4: U kojoj utakmici je palo najvise golova u drugom poluvremenu?
-- Ko je igrao: Northport United & Newbury Forest
-- Rezultat na poluvremeu: 1:0
-- Rezultat na kraju:6:3

SELECT home_team, away_team, home_goals_ht, away_goals_ht, home_goals, away_goals, (home_goals + away_goals) - (home_goals_ht + away_goals_ht) AS second_ht_goals
FROM bootcamp.domaci.matches_flat
ORDER BY second_ht_goals DESC
 LIMIT 1;


-- Zadatak 5: Koliko utakmica sezone 2023/24 je odigrano po snegu ili magli
-- 109
SELECT * FROM bootcamp.domaci.matches_flat
WHERE (weather = 'rain' OR weather = 'fog')
AND   season = '2023/24' ;

-- Zadatak 6: Prikazite sve utakmice gradskog derbija izmedju Northport United i Northport City, bez obzira na to ko je domacin, sortirane po datumu, ko je pobedio u kom mecu? 

SELECT home_team, away_team, kickoff_ts, home_goals, away_goals
FROM bootcamp.domaci.matches_flat
WHERE (home_team = 'Northport United' OR home_team =  'Northport City')
AND (away_team = 'Northport United' OR  away_team = 'Northport City')
ORDER BY kickoff_ts ASC;


-- Zadatak 7 : Prikazite prve tri utakmice sezone 2024/25 po vremenu pocetka. 
--Da li mozete biti sigurni koja je druga a koja treca: Ne, u isto vreme su pocele

SELECT kickoff_ts, season
FROM bootcamp.domaci.matches_flat
WHERE season = '2024/25'
ORDER BY kickoff_ts ASC
LIMIT 3;

-- Zadatak 8 : Prikazite sve utakmice u kojima je prvi gol dao Sean O'Neill
--Koliko ih je? 2

SELECT * FROM bootcamp.domaci.matches_flat
WHERE first_goal_scorer = "Sean O'Neill";
