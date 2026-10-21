--DOMACI ZADATAK 3.1

--ZADATAK 1:  Za svaku sezonu prikažite ukupan broj utakmica, ukupan broj postignutih golova i prosečan broj golova po utakmici.

SELECT season, COUNT(*) AS ukupan_broj_ukamica,
SUM (home_goals + away_goals) AS ukupan_broj_golova,
AVG (home_goals + away_goals) AS prosecan_broj_golova
FROM matches_flat
GROUP BY season;

--ZADATAK 2: Za svaki stadion prikažite najmanju, najveću i prosečnu zabeleženu posetu, kao i broj utakmica za koje je poseta poznata.

SELECT stadium_name,
MIN(attendance) AS minimalna_posecenost,
MAX(attendance) AS maximalna_posecenost,
AVG(attendance) AS prosecna_posecenost,
COUNT(attendance) AS broj_utakmica
FROM matches_flat
GROUP BY stadium_name;

--ZADATAK 3: Prikažite sudije koje su sudile najmanje 10 utakmica i koje su ukupno pokazale najmanje 20 žutih kartona. Prikažite ime sudije, broj utakmica i ukupan broj žutih kartona.

SELECT referee_name, 
SUM(home_yellow_cards+ away_yellow_cards) AS ukupan_broj_zutih_kartona,
COUNT(*) AS ukupan_broj_utakmica
FROM matches_flat
GROUP BY referee_name
HAVING ukupan_broj_utakmica >=10
AND ukupan_broj_zutih_kartona >=20;

--ZADATAK 4: Podelite utakmice prema ukupnom broju golova na kategorije Bez golova (0), Malo golova (1 ili 2) i Mnogo golova (3 ili više). Prikažite broj utakmica u svakoj kategoriji i najveći broj golova na utakmici u toj kategoriji.

SELECT 
 CASE WHEN (home_goals + away_goals) = 0 THEN 'Bez golova'
      WHEN (home_goals + away_goals) <= 2 THEN 'Malo golova'
      ELSE 'Mnogo golova'
      END AS broj_golova,
COUNT(*) AS broj_utakmica,
MAX(home_goals + away_goals) AS najveci_broj_golova
FROM matches_flat
GROUP BY CASE WHEN (home_goals + away_goals) = 0 THEN 'Bez golova'
      WHEN (home_goals + away_goals) <= 2 THEN 'Malo golova'
      ELSE 'Mnogo golova'
      END;


--ZADATAK 5:  Za svaki klub prikažite broj utakmica koje je odigrao kao domaćin, broj pobeda kod kuće i broj poraza kod kuće. U rezultat uključite samo klubove koji su kod kuće odigrali najmanje 10 utakmica.

SELECT home_team,
COUNT(*) AS broj_utakmica,
SUM (CASE
      WHEN (home_goals > away_goals) THEN 1
        ELSE 0 END) AS broj_pobeda_kod_kuce,
SUM (CASE
     WHEN(home_goals < away_goals) THEN 1
     ELSE 0 END) AS broj_poraza_kod_kuce
FROM matches_flat
GROUP BY home_team
HAVING broj_utakmica >= 10;

--ZADATAK 6: Za svakog sudiju prikažite ukupan broj utakmica, broj utakmica u kojima je pokazao bar jedan crveni karton i procenat takvih utakmica u odnosu na sve utakmice koje je sudio.

SELECT referee_name,
COUNT (*) AS ukupan_broj_utakmica,
SUM (CASE
        WHEN (home_red_cards > 0) OR (away_red_cards >0) THEN 1
        ELSE 0 END) AS broj_utakmica_sa_crvenim_kartonom,
broj_utakmica_sa_crvenim_kartonom/ukupan_broj_utakmica * 100 AS procenat_utakmica_sa_crvenim_kartonom
FROM matches_flat
GROUP BY referee_name;

--Zadatak 7: Za svaku sezonu prikažite broj pobeda domaćina, broj nerešenih utakmica i broj pobeda gostiju. Takođe prikažite procenat utakmica koje su završene nerešenim rezultatom.

SELECT season, 
SUM (CASE
     WHEN (home_goals > away_goals) THEN 1
     ELSE 0 END) AS pobeda_domacina,
SUM (CASE
     WHEN (home_goals = away_goals) THEN 1
     ELSE 0 END) AS nereseno,
SUM (CASE WHEN (home_goals < away_goals) THEN 1
     ELSE 0 END) AS pobeda_gostiju,
nereseno/COUNT (*) * 100 AS procenat_neresenih
FROM matches_flat
GROUP BY season;