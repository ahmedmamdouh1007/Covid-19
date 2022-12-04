---Data inquiry

SELECT *
FROM Covi19..CovidDeaths
ORDER BY 1

SELECT *
FROM Covi19..CovidVaccinations
ORDER BY 1


--- Select Data That Im going to be using
SELECT continent, location, date, total_cases, new_cases, total_deaths
FROM Covi19..CovidDeaths
ORDER BY 2, 3;

SELECT continent, 
       location, 
	   date, 
	   total_vaccinations, 
	   new_vaccinations, 
	   total_tests, 
	   new_tests
FROM Covi19..CovidVaccinations
ORDER BY total_vaccinations
Desc;

--- Q1: Showing total  cases vs total deaths
SELECT location, date, CAST(total_deaths AS float) AS TotalDeaths, total_cases, 
                      (CAST(total_deaths AS float)/ total_cases)*100 as DeathsPerc
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

--- showing in Egypt  
SELECT location, date, CAST(total_deaths AS float) AS TotalDeaths, total_cases, 
                      (CAST(total_deaths AS float)/ total_cases)*100 as DeathsPerc
FROM Covi19..CovidDeaths
WHERE location = 'Egypt' and 
      continent IS NOT NULL
ORDER BY 1, 2


---Q2: Top 10 Location, continent with most covid cases and how many cases from this top10 have vaccinations
SELECT TOP 10 D.location, SUM(D.total_cases) AS cases, SUM(CONVERT(float, V.total_vaccinations)) AS vaccinations
FROM Covi19..CovidDeaths AS D
JOIN Covi19..CovidVaccinations AS V
ON D.iso_code = V.iso_code
GROUP BY D.location
ORDER BY 3
DESC; 


---Q3: showing Total Cases VS Population by location
SELECT location, 
       date, 
	   total_cases, 
	   population, 
	   (total_cases/ population)*100 AS TotalCasesPerc
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

---Q4: showing Highest Rate TotalCasesPerc ---> in every country
SELECT location, population, 
                 MAX(total_cases) AS HightCases,  
			     MAX(total_cases/ population)*100 AS HighestCasesPerc
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestCasesPerc
DESC;


---Q5: showing Highest Deaths Count per ---> by country

SELECT location, population, 
       MAX(convert(float, total_deaths)) AS HighestDeathsCount
                             
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestDeathsCount
DESC;

---Q6: showing Highest Deaths Count per ---> by continent
SELECT continent,
       MAX(convert(float, total_deaths)) AS HighestDeathsCount
                             
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathsCount
DESC;

---Q7: Showing New Global numbers ---> Deaths, Cases
SELECT SUM(convert(float, new_deaths)) AS TotalDeaths,
       SUM(new_cases) AS TotalCases,
	   SUM(convert(float, new_deaths))/ SUM(new_cases)  *100 AS TotalDeathsPerc                            
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL

---Q8: Showing Highest Deaths, Vaccinations for every continent

SELECT D.continent, MAX(D.total_cases) AS Cases, 
MAX(CONVERT(int, V.total_vaccinations)) AS vaccinations, 
MAX(CONVERT(int, D.total_deaths)) AS Deaths
FROM Covi19..CovidDeaths AS D
JOIN Covi19..CovidVaccinations AS V
ON D.iso_code = V.iso_code
WHERE D.continent IS NOT NULL
GROUP BY D.continent
ORDER BY 1;


SELECT *
FROM Covi19..CovidDeaths
ORDER BY 2 DESC;
SELECT *
FROM Covi19..CovidVaccinations
ORDER BY 2 DESC;

--- Showing People Vaccinated of Rolling

WITH NEW(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(INT, V.new_vaccinations)) OVER(PARTITION BY D.Location ORDER BY D.location, D.date) as RollingPeopleVaccinated
FROM Covi19..CovidDeaths AS D
JOIN Covi19..CovidVaccinations AS V
     ON D.location = V.location
     AND D.date = V.date
WHERE D.continent IS NOT NULL
--group by D.continent, D.location, D.date, D.population, V.new_vaccinations
--ORDER BY 2, 3
)

SELECT*, (RollingPeopleVaccinated/ population)*100 AS RollingPeopleVaccinatedPerc
FROM NEW


--Creat Table for People Vaccinated of Rolling

--DROP TABLE IF EXISTS #NEWTABLE
--CREATE TABLE #NEWTABLE
--(continent nvarchar(255),
--location nvarchar(255), 
--date datetime, 
--population numeric, 
--new_vaccinations numeric, 
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #NEWTABLE
--SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
--SUM(CONVERT(INT, V.new_vaccinations)) OVER(PARTITION BY D.Location ORDER BY D.location, D.date) as RollingPeopleVaccinated
--FROM Covi19..CovidDeaths AS D
--JOIN Covi19..CovidVaccinations AS V
--ON D.location = V.location
--AND D.date = V.date
--WHERE D.continent IS NOT NULL
----group by D.continent, D.location, D.date, D.population, V.new_vaccinations

--SELECT*
--FROM #NEWTABLE