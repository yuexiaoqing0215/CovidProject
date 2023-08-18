--Looking at total cases vs total deaths in Singapore, which shows likelyhood of dying if one contract Covid in Singapore
select location, date, total_cases, total_deaths, (convert(float, total_deaths)/convert(float, total_cases))*100 as DeathPercentage
from CovidData
where location = 'Singapore'
order by 1,2

--Looking at total cases vs population, which shows what percentage of population got Covid
select location, date, population, total_cases, (convert(float, total_cases)/population)*100 as CovidPercentage
from CovidData
where location = 'Singapore'
order by 1,2

--Looking at Countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from CovidData
group by location, population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidData
where continent is not null
group by location
order by TotalDeathCount desc

--Showing continents with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidData
where continent is null and location !='Upper middle income' and location !='High income' and location !='Lower middle income' and location !='Low income'
group by location
order by TotalDeathCount desc

--Looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations
from CovidData dea
join CovidVac vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null
order by 2,3

--Use CTE 
with PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, sum(cast(vac.total_vaccinations as bigint))
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidData dea
join CovidVac vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null)

select *, (RollingPeopleVaccinated/population)*100 as RollingVaccinatedPercent
from PopvsVac
