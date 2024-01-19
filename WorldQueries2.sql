-- 1. a rekordok száma: 7
SELECT Continent, COUNT(*) AS CountryCount
FROM country
GROUP BY Continent
ORDER BY CountryCount DESC;

-- 2a. a rekordok száma: 51
SELECT Name AS CountryName, Capital AS CapitalName
FROM country
WHERE Continent = 'Asia'
ORDER BY CountryName;

-- 2b.
SELECT Name AS CountryName, Capital AS CapitalName
FROM country
WHERE Continent = 'Europe'
ORDER BY CountryName;

-- 2c. a rekordok száma: 14
SELECT Name AS CountryName, Capital AS CapitalName
FROM country
WHERE Continent = 'South America'
ORDER BY CountryName;

-- 3a. a rekordok száma: 250
SELECT c.Name AS Country, ct.Name AS City, ct.Population
FROM country c
JOIN city ct ON c.Code = ct.CountryCode
WHERE c.Name = 'Brazil'
ORDER BY ct.Population DESC;

-- 3b.  a rekordok száma: 93
SELECT c.Name AS Country, ct.Name AS City, ct.Population
FROM country c
JOIN city ct ON c.Code = ct.CountryCode
WHERE c.Name = 'Germany'
ORDER BY ct.Population DESC;

-- 4a. a rekordok száma: 239
SELECT c.Name AS Country, COUNT(ct.Name) AS CityCount
FROM country c
LEFT JOIN city ct ON c.Code = ct.CountryCode
GROUP BY c.Name
ORDER BY CityCount DESC;

-- 4b. a rekordok száma: 232
SELECT c.Name AS Country, COUNT(ct.Name) AS CityCount
FROM country c
LEFT JOIN city ct ON c.Code = ct.CountryCode
GROUP BY c.Name
HAVING CityCount > 0
ORDER BY CityCount DESC;

-- 5. a rekordok száma: 239
SELECT c.Name AS Country,
       ROUND(SUM(ct.Population) / (SELECT SUM(Population) FROM country) * 100, 1) AS PopulationPercentage
FROM country c
LEFT JOIN city ct ON c.Code = ct.CountryCode
GROUP BY c.Name
ORDER BY Country;

-- 6a. a rekordok száma: 38
SELECT c.Name AS Country, c.Population
FROM country c
WHERE (SELECT COUNT(*) FROM countrylanguage cl WHERE cl.CountryCode = c.Code AND cl.IsOfficial = 'T') > 1
ORDER BY c.Population DESC;

-- 6b. a rekordok száma: 239
SELECT c.Name AS Country, COUNT(cl.Language) AS OfficialLanguageCount
FROM country c
LEFT JOIN countrylanguage cl ON c.Code = cl.CountryCode AND cl.IsOfficial = 'T'
GROUP BY c.Name
ORDER BY OfficialLanguageCount DESC, c.Name;

-- 7. a rekordok száma: 1000
SELECT ct.Name AS City, 
       ROUND((ct.Population / c.Population * 100), 1) AS PopulationPercentage,
       c.Name AS Country
FROM city ct
JOIN country c ON ct.CountryCode = c.Code
ORDER BY c.Name, ct.Name;

-- 8a. a rekordok száma: 1000
SELECT Name AS City, Population
FROM city
ORDER BY Population DESC
LIMIT 3;

-- 8b. a rekordok száma: 15
SELECT Name AS City, Population
FROM city
ORDER BY Population DESC
LIMIT 15;

-- 9a. a rekordok száma: 19
SELECT c.Name AS Country
FROM country c
WHERE EXISTS (
    SELECT 1
    FROM countrylanguage cl
    WHERE cl.CountryCode = c.Code
    AND cl.Language = 'German'
)
ORDER BY c.Name;

-- 9b. a rekordok száma: 19
SELECT c.Name AS Country, c.Population
FROM country c
WHERE EXISTS (
    SELECT 1
    FROM countrylanguage cl
    WHERE cl.CountryCode = c.Code
    AND cl.Language = 'German'
)
ORDER BY c.Population DESC, c.Name;

-- 10. a rekordok száma: 1000
SELECT ct.Name AS City, CASE WHEN ct.ID = c.Capital THEN c.Name ELSE '' END AS Country
FROM city ct
LEFT JOIN country c ON ct.CountryCode = c.Code;

-- 11. a rekordok száma: 2
SELECT YEAR(IndepYear) AS Year, COUNT(*) AS IndependentCountries
FROM country
WHERE IndepYear IS NOT NULL
GROUP BY YEAR(IndepYear)
ORDER BY IndependentCountries DESC, YEAR(IndepYear) DESC;

-- 12. a rekordok száma: 5, a legtöbbet beszélt nyelvek: kínai, hindi, angol, spanyol, arab
SELECT cl.Language AS Language, SUM(c.Population) AS TotalSpeakers
FROM country c
JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'
GROUP BY cl.Language
ORDER BY TotalSpeakers DESC
LIMIT 5;
Select * from country;

-- 13. a rekordok száma: 1, a legkevesebbet beszélt nyelv: Sinaberberi
SELECT Language
FROM countrylanguage
GROUP BY Language
ORDER BY SUM(Percentage) ASC
LIMIT 1;

-- 14a. a rekordok száma: 1, Syria lélekszámaközelíti meg leginkább Hollandia lélekszámát
SELECT a.Name AS AsianCountry, a.Population AS AsianPopulation, 
       h.Name AS Holland, h.Population AS HollandPopulation, 
       ABS(a.Population - h.Population) AS PopulationDifference
FROM country a
JOIN country h ON h.Name = 'Netherlands'  -- Hollandia
WHERE a.Continent = 'Asia'
ORDER BY PopulationDifference
LIMIT 1;

-- 14b. a rekordok száma: 1, Cape Verde népsűrűsége van a legközelebb Magyarország népsűrűségéhez
SELECT a.Name AS AfricanCountry, a.Population / a.SurfaceArea AS AfricanPopulationDensity,
       h.Name AS Hungary, h.Population / h.SurfaceArea AS HungarianPopulationDensity,
       ABS(a.Population / a.SurfaceArea - h.Population / h.SurfaceArea) AS PopulationDensityDifference
FROM country a
JOIN country h ON h.Name = 'Hungary' -- Magyarország
WHERE a.Continent = 'Africa'
ORDER BY PopulationDensityDifference
LIMIT 1;