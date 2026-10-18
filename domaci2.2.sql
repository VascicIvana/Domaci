--DOMACI 2.2

--Zadatak 1: Pronađite sve utakmice čiji naslov ('match_report') sadrzi rec 'goal' bez obzira na velika i mala slova

SELECT *
FROM bootcamp.domaci.matches_flat
WHERE match_report ILIKE '%goal%';

--Zadatak 2: Napravi kolonu 'referee_name' tako da sadrzi ime sudije ako postoji a tekst 'Unknown' ako nedostaje podatak. Prikazi 20 utakmica

SELECT 
COALESCE(referee_name, 'Unknown') AS referee_name
FROM bootcamp.domaci.matches_flat
ORDER BY kickoff_ts
LIMIT 20;


--Zadatak 3: Prikazi utakmce ciji je naslov duzi od 40 znakova. Prikazi naslov i broj znakova u njemu

SELECT match_report,
LENGTH (match_report) AS report_length
FROM bootcamp.domaci.matches_flat
WHERE LENGTH(match_report) > 40;

--Zadatak 4: Prikazi utakmice odigrane od 1. do 15. januara 2025. ukljucujuci oba datuma

SELECT *
FROM bootcamp.domaci.matches_flat
WHERE kickoff_ts >= '2025-01-01'
AND kickoff_ts <  '2025-01-16';


--Zadatak 5: Prebroj utakmice odigrane petkom. Prikazi datum i dan u nedelji za svaku od njih

SELECT COUNT(*)
FROM bootcamp.domaci.matches_flat
WHERE DAYOFWEEK(kickoff_ts) = 6;


--Zadatak 6: Koliko utakmica sezone '2024/25' je imalo izmedju 20000 i 35000 gledalaca ukljucujuci obe granice

SELECT COUNT(*)
FROM bootcamp.domaci.matches_flat
WHERE season = '2024/25'
AND attendance BETWEEN 20000 AND 35000;


--Zadatak 7: Pronadji strelce prvog gola cije ime pocinje slovom 'A' ili sadrzi crticu, prikazi samo razlicita imena

SELECT DISTINCT first_goal_scorer
FROM bootcamp.domaci.matches_flat
WHERE first_goal_scorer LIKE 'A%'
OR first_goal_scorer LIKE '%-%';


--Zadatak 8: Prikazi utakmice sezone 2024/25 koje su pocele izmedju 18:00 i 21:00 ukljucujuci obe granice i prikazi vreme pocetka i nazive timova 

SELECT kickoff_ts, home_team, away_team
FROM bootcamp.domaci.matches_flat
WHERE season = '2024/25'
AND HOUR(kickoff_ts) BETWEEN 18 AND 21;

--Zadatak 9: Prebroj utakmice odigrane u martu, aprilu ili maju 2025. godine ciji naslov sadrzi 'win'bez obzira na velicinu slova

SELECT COUNT(*)
FROM bootcamp.domaci.matches_flat
WHERE kickoff_ts >= '2025-03-01'
AND kickoff_ts <  '2025-06-01'
 AND match_report ILIKE '%win%';
