--*7. Prikazati imena svih upravnika cije idbr rukovodilaca je 5842 ali cija je plata ili strogo iznad ili strogo ispod 2400 a koji nisu u odeljenju ciji je broj 30 ili 40.
SELECT ime
FROM radnik
WHERE posao = 'upravnik'
  AND rukovodilac = 5842
  AND (plata > 2400 OR plata < 2400)
  AND broj_odeljenja NOT IN (30, 40);
  
  
--*11. Prikazati idbr onih koji se zovu 'Biljana' ili 'Strahinja', koji se ne zovu 'Amanda', ciji broj rokuvodilaca je neki od brojeva 5555, 6666 ili 7777, ali tako da im je premija strogo manja od 500 uz platu strogo vecu od 1000 ili tako da im je premija veca ili jednaka od 500 uz platu manju ili jednaku od 1000.
SELECT idbr 
FROM radnik 
WHERE ime IN ('Biljana', 'Strahinja') 
AND NOT ime = 'Amanda' 
AND rukovodilac IN (5555, 6666, 7777) 
AND ((premija < 500 AND plata > 1000) OR (premija >=500 AND plata <=1000));


--*13. Prikazati poslove za koje je potrebna VSS kvalifikacija (paziti dobro na rezultat ovog upita).
SELECT DISTINCT posao FROM radnik WHERE kvalifikacija = 'VSS';


--*18. Prikazati idbr radnika od najveceg ka najmanjem cije ime ima slovo 'c' na 2. mestu u imenu ili slovo 'v' na 3. mestu ili  slovo 'o' na 4. mestu ili da ima sekvencu 'as' negde u imenu.
SELECT idbr
FROM radnik
WHERE ime LIKE '_c%'
   OR ime LIKE '__v%'
   OR ime LIKE '___o%'
   OR ime LIKE '%as%'
ORDER BY idbr DESC;


--*23. Za svaku funkciju, za svaki broj sati prikazati maksimalni broj sati poredjano  maksimalnom broju projekata silazno
SELECT funkcija, broj_sati, MAX(broj_projekta) AS maksimalni_broj_projekata
FROM ucesce
GROUP BY funkcija, broj_sati
ORDER BY maksimalni_broj_projekata DESC;


--*25. Prikazati najvecu premiju i najmanju platu za svaku funkciju, uzimajuci u obzir samo premije i plate onih radnika koji imaju rukovodioca.
SELECT funkcija,
       MAX(r.premija) AS najveca_premija,
       MIN(r.plata) AS najmanja_plata
FROM radnik r
JOIN ucesce u ON r.idbr = u.idbr
WHERE rukovodilac IS NOT NULL
GROUP BY funkcija;


--*26. Prikazati one poslove koji imaju strogo vise od 2 radnika.
SELECT posao FROM radnik ;
SELECT idbr FROM ucesce GROUP BY idbr HAVING COUNT(idbr) > 2;

SELECT posao 
FROM radnik 
WHERE idbr IN (SELECT idbr FROM ucesce GROUP BY idbr HAVING COUNT(idbr) > 2);


--*27. Prikazati kvalifikacije i njihove minimalne i maximalne plate uzimajuci u obzir samo plate vece do 1000 i zanemarujuci maksimalne plate manje od 2000
SELECT kvalifikacija,
       MIN(plata) AS minimalna_plata,
       MAX(plata) AS maksimalna_plata
FROM radnik
WHERE plata > 1000 
GROUP BY kvalifikacija
HAVING MAX(plata) >= 2000;


--29*. Za svaku funkciju prikazati ono mesto na kome radi najvise radnika.
SELECT r.posao, o.mesto, COUNT(*) AS broj_radnika
FROM radnik r
JOIN odeljenje o ON r.broj_odeljenja = o.broj_odeljenja
GROUP BY r.posao, o.mesto
HAVING COUNT(*) = (SELECT MAX(broj_radnika)
                   FROM (SELECT r.posao, o.mesto, COUNT(*) AS broj_radnika
                         FROM radnik r
                         JOIN odeljenje o ON r.broj_odeljenja = o.broj_odeljenja
                         GROUP BY r.posao, o.mesto) AS counts);


--*31. Prikazati za svako odeljenje ime radnika koji ima najvise odradjenih broja sati a koji nije na projektu 'izvoz', uzimajuci u obzir samo radnike kome je zadata neka (bilo kakva) premija.
SELECT o.ime_odeljenja, 
       MAX(r.ime) AS ime_radnika,
       MAX(u.broj_sati) AS maksimalni_broj_sati
FROM ucesce u
JOIN radnik r ON u.idbr = r.idbr
JOIN odeljenje o ON r.broj_odeljenja = o.broj_odeljenja
JOIN projekat p ON u.broj_projekta = p.broj_projekta
WHERE p.imeproj <> 'izvoz' AND r.premija IS NOT NULL
GROUP BY o.ime_odeljenja;


--*32. Prikazati par razlicitih imena koji rade na istoj poziciji i zavrsavaju se na slovo 'o' poredjanih leksikografski od najveceg ka najmanjem po prvom imenu a leksikografski od najmanjeg ka najvecem po drugom imenu (dodatni zadatak, neobavezan: Prikazati par imena koji rade na istoj poziciji i zavrsavaju se na isto slovo poredjanih leksikografski od najveceg ka najmanjem po prvom imenu a leksikografski od najmanjeg ka najvecem po drugom imenu <- moracete da guglujete za ovo)
SELECT DISTINCT r1.ime AS prvo_ime, r2.ime AS drugo_ime
FROM radnik r1
JOIN radnik r2 ON r1.posao = r2.posao AND r1.ime < r2.ime
WHERE RIGHT(r1.ime, 1) = 'o' AND RIGHT(r2.ime, 1) = 'o'
ORDER BY prvo_ime DESC, drugo_ime ASC;



--*33. Prikazati na kom mestu je odeljenje koje ima prosecnu platu medju odeljenjima, racunajuci prosek sa tacnoscu od dve decimale. (paziti DOOOBROOO sta vam se ovde tacno trazi!) (Resenje: 'Banovo Brdo')
SELECT o.mesto, ROUND(AVG(r.plata), 2) AS prosecna_plata
FROM odeljenje o
JOIN radnik r ON o.broj_odeljenja = r.broj_odeljenja
GROUP BY o.mesto
ORDER BY prosecna_plata DESC
LIMIT 1;

