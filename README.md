SELECT * FROM dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT * FROM ..CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population FROM..CovidDeaths
ORDER BY 1,2

-- looking at total cases vs total deaths
--shows likelyhood of dying if you contract covid in USA
SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage FROM..CovidDeaths
WHERE location like'%states%'
ORDER BY 1,2

--Looking at total cases vs population
--shows what persentage of population got covid
SELECT Location, date, population,total_cases, (total_cases/population)*100 as deathpercentage FROM..CovidDeaths
WHERE location like'%states%'
ORDER BY 1,2

--looking at countries with highest infection rate compared to population
SELECT Location, population, MAX(total_cases) as HighestInfectioncount, MAX((total_cases/population))*100 as percentofpopulationinfected FROM..CovidDeaths
--WHERE location like'%states%'
GROUP BY Location, population
ORDER BY percentofpopulationinfected desc

--showing countries with the highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as totaldeathcount FROM CovidDeaths
--WHERE location like'%states%'
WHERE continent is null
GROUP BY location
ORDER BY totaldeathcount desc


--GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage 
FROM..CovidDeaths
--WHERE location like'%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2 


--looking at total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated,
FROM..CovidDeaths dea
join ..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From..CovidDeaths dea
Join..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
