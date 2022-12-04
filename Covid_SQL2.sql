--- REVIEW DATA
SELECT * 
FROM Covi19..CovidDeaths

SELECT *
FROM Covi19..CovidDeaths

--- Select Data That Im going to be using
SELECT continent, location, date, total_cases, new_cases, new_deaths,  total_deaths, population, median_age
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 2, 3
DESC;

SELECT continent, location, date, total_vaccinations, new_vaccinations, total_tests, new_tests, positive_rate, median_age
FROM Covi19..CovidVaccinations 
WHERE continent IS NOT NULL
ORDER BY 2, 3
Desc;

َ--- Q1: Showing population in the world
SELECT location, sum(population) as popualtion 
FROM Covi19..CovidDeaths
WHERE location = 'world'
group by location

---Q2: Showing how many  people have vaccinations in the world 
SELECT location, sum(convert(float , total_vaccinations)) as vaccinations
FROM Covi19..CovidVaccinations
WHERE location = 'world' and 
total_vaccinations is not null
group by location

--- percentage of vaccinations in the world
SELECT location, date, (SUM(CAST(total_vaccinations AS FLOAT)) / SUM(population)) * 100 AS VaccinationPerc
FROM Covi19..CovidDeaths
WHERE location = 'world'
and 
population is not null
and 
total_vaccinations is not null
group by location, date
order by 1,2 DESC;

---Q3: Showing How Many cases (New, Past) by continent and in 3 years?
SELECT continent, date, SUM(total_cases + new_cases) AS cases
FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, date
ORDER BY 1, 2


--Q4: median ages for all deaths per country
SELECT location, MAX(median_age) as ages
FROM Covi19..CovidDeaths
WHERE 
continent IS NOT NULL
group by location
ORDER BY 1


--SELECT continent, MAX(median_age) as ages
--FROM Covi19..CovidDeaths
--WHERE continent is not null
--GROUP BY continent


---Q6: highest cases perc. per population for every country
SELECT location, date, total_cases, population, (total_cases/population)* 100 AS TotalCasesPerc
FROM Covi19..CovidDeaths
ORDER BY 1, 2


SELECT location, MAX(total_cases) as cases, MAX(population) as population, Max(total_cases/population)* 100 AS TotalCasesPerc
FROM Covi19..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY 1, 2
 

--Q7: vaccination perc. per population 
SELECT D.location, SUM(CAST(V.total_vaccinations as float)) AS vaccination, SUM(D.population) as population,
                   SUM(CAST(V.total_vaccinations as float))/SUM(D.population)*100 AS VaccinationPerc
FROM Covi19..CovidDeaths AS D
JOIN Covi19..CovidVaccinations AS v
ON V.continent = D.continent
AND
V.location = D.location
GROUP BY D.location
ORDER BY 4 DESC;


--Q8: Deaths Perc. per population and cases over 3 years

SELECT location, date, CAST(total_deaths AS float) AS total_deaths, population,
					   CAST(total_deaths AS float)/ population * 100 as DeathsPPopulation

FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 2;


SELECT location, date, CAST(total_deaths AS float) AS total_deaths, 
                       CAST(total_cases AS float) AS total_cases,
					   CAST(total_deaths AS float)/ CAST(total_cases AS float) * 100 as DeathsPCases

FROM Covi19..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 2;






