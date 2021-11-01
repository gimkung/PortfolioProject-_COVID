--Check Data
/*SELECT *
FROM PortfolioProject..[Covid-Death]
ORDER BY 3,4

SELECT *
FROM PortfolioProject..[Covid-Vaccination]
ORDER BY 3,4*/

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..[Covid-Death]
ORDER BY location, date

-- Looking at Total Cases VS Total Deaths
-- Percentage of Death from COVID in Thailand
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..[Covid-Death]
where location = 'Thailand'
ORDER BY location, date DESC

-- Looking at Total Cases VS Population

SELECT location, date, total_cases, population,(total_cases/population)*100 AS Infected_Percentage
FROM PortfolioProject..[Covid-Death]
WHERE location = 'Thailand'
ORDER BY location, date DESC

--looking at countries with Highest Infection Rate

SELECT location, date, max(total_cases) AS Highest_Case_Percountry, max((total_cases/population)) AS Max_Percentage
FROM PortfolioProject..[Covid-Death]
GROUP BY location, date
ORDER BY Max_Percentage DESC

--looking at countries with Total Death Count

SELECT location, MAX(CAST(total_deaths AS int)) AS Death_Count
FROM PortfolioProject..[Covid-Death]
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Death_count DESC

--looking up Total Death Count Per Continent

SELECT location, MAX(CAST(total_deaths AS int)) AS Death_Count
FROM PortfolioProject..[Covid-Death]
WHERE continent IS NULL
GROUP BY location
ORDER BY Death_Count DESC

--Global Number

SELECT date, total_cases, total_deaths
FROM PortfolioProject..[Covid-Death]

SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths,
(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS Glob_Death_Percentage
FROM PortfolioProject..[Covid-Death]

-- Looking at Total_Population VS Vaccination

SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(NUMERIC,V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.date) AS CountVaccinated
FROM PortfolioProject..[Covid-Death] AS D
INNER JOIN PortfolioProject..[Covid-Vaccination] AS V
ON D.location = V.location and D.date = V.date
WHERE D.continent IS NOT NULL 

--USE CTE to Calculate Percentage of Vaccinated population per country
WITH PopVSVac as (
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(NUMERIC,V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.date) AS CountVaccinated
FROM PortfolioProject..[Covid-Death] AS D
INNER JOIN PortfolioProject..[Covid-Vaccination] AS V
ON D.location = V.location and D.date = V.date
WHERE D.continent IS NOT NULL )

SELECT * , (CountVaccinated/population)*100 AS Vaccinated_Percentage
FROM PopVSVac

-- Create Temp Table
DROP TABLE IF EXISTS #VaccinatedPopulationPercentage
CREATE TABLE  #VaccinatedPopulationPercentage
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
CountVaccinated numeric
)
INSERT INTO #VaccinatedPopulationPercentage
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(NUMERIC,V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.date) AS CountVaccinated
FROM PortfolioProject..[Covid-Death] AS D
INNER JOIN PortfolioProject..[Covid-Vaccination] AS V
ON D.location = V.location and D.date = V.date
WHERE D.continent IS NOT NULL


select *
from #VaccinatedPopulationPercentage





-- Create View to store data for visualization

CREATE VIEW Vaccinated as
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(NUMERIC,V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.date) AS CountVaccinated
FROM PortfolioProject..[Covid-Death] AS D
INNER JOIN PortfolioProject..[Covid-Vaccination] AS V
ON D.location = V.location and D.date = V.date
WHERE D.continent IS NOT NULL

SELECT *
FROM Vaccinated
















