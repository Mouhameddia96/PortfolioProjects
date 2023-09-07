# COVID-19 Data Exploration

--  Combined data using **Joins** for comprehensive insights.
--  Simplified complex queries with **CTEs** and **Temporary Tables**.
--  Employed **Window** and **Aggregate Functions** for detailed analysis.
--  Created **Views** for efficient query access.
--  Managed data consistency through **Type Conversions**.

SELECT *
From `myportfolio-398102.Portfolio.CovidDeath`
order by 3,4

-- SELECT *
-- FROM `myportfolio-398102.Portfolio.CovidVaccinations`
-- order by 3,4

--Select Data that we are going to be using


SELECT Location, date, total_cases, new_cases, total_deaths, population
From `myportfolio-398102.Portfolio.CovidDeath`
order by 1,2

-- Looking at Total cases Vs Total Deaths
--This shows the likelihood of dying if you contract covid in your loaction(country)


SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From `myportfolio-398102.Portfolio.CovidDeath`
WHERE location like '%states%'
order by 1,2

--Looking at Total Cases Vs Population
--shows what percentage of population got Covid

SELECT Location, date,population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From `myportfolio-398102.Portfolio.CovidDeath`
WHERE location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Raye compared to Population

SELECT Location,population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From `myportfolio-398102.Portfolio.CovidDeath`
--WHERE location like '%states%'
group by Location,population
order by PercentPopulationInfected desc

--Countries with Highest Death Count per population
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
From `myportfolio-398102.Portfolio.CovidDeath`
WHERE continent is not null
group by Location
order by TotalDeathCount desc

-- Breaking Things Down By Continent
--Showing Continents with the highest death count per populatin

SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
From `myportfolio-398102.Portfolio.CovidDeath`
WHERE continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers


SELECT Sum(new_cases)as total_cases, Sum(cast(new_deaths as int)) as total_death,Sum(cast(new_deaths as int)) / Sum(new_cases) *100 as DeathPercentage
From `myportfolio-398102.Portfolio.CovidDeath`
WHERE continent is not null
--group by date
order by 1,2

--Looking at Total Population Vs Vaccinations
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(cast( vac.new_vaccinations as int)) over (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM `myportfolio-398102.Portfolio.CovidDeath` dea
JOIN `myportfolio-398102.Portfolio.CovidVaccinations` vac
  ON dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3

-- USE CTE
WITH PopvsVac AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date,
        dea.population, 
        vac.new_vaccinations, 
        SUM(CAST(vac.new_vaccinations AS int)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM `myportfolio-398102.Portfolio.CovidDeath` dea
    JOIN `myportfolio-398102.Portfolio.CovidVaccinations` vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

--Temp Table
WITH PercentPopulationVaccinated AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date,
        dea.population, 
        vac.new_vaccinations, 
        SUM(CAST(vac.new_vaccinations AS INT)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM `myportfolio-398102.Portfolio.CovidDeath` dea
    JOIN `myportfolio-398102.Portfolio.CovidVaccinations` vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)

SELECT *, 
       CAST((RollingPeopleVaccinated / population) * 100 AS INT) AS PercentVaccinated
FROM PercentPopulationVaccinated;

--Creating View to store data for later for visualizations

create view myportfolio-398102.Portfolio.PercentPopulationVaccinated  as

SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(cast( vac.new_vaccinations as int)) over (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM `myportfolio-398102.Portfolio.CovidDeath` dea
JOIN `myportfolio-398102.Portfolio.CovidVaccinations` vac
  ON dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent is not null

























