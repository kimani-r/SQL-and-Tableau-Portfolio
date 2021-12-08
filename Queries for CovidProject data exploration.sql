--queries for CovidProject data exploration 
--Skills used: Converting Data Types
*/

select *
from CovidProject.dbo.CovidData
where continent is not null 
order by 3,4



--cases and deaths per country
select location, date, total_cases, new_cases, total_deaths, population
from CovidProject.dbo.CovidData
where continent is not null 
order by 1,2


--total cases vs total deaths filtered by country
--likelihood of one dying if they contract covid in Kenya
select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from CovidProject.dbo.CovidData
where location like '%kenya%'
and continent is not null 
order by 1,2


--total cases vs population
--percentage of the population infected with covid
select location, date, population, total_cases,  (total_cases/population)*100 as percent_population_infected
from CovidProject.dbo.CovidData
--where location like '%kenya%'
order by 1,2


--countries with the highest infection rate compared to population
select location, population, max(total_cases) as highest_infection_count,  max((total_cases/population))*100 as percent_population_infected
from CovidProject.dbo.CovidData
group by location, population
order by percent_population_infected desc


--countries with the highest death count
select location, max(cast(total_deaths as int)) as total_death_count
from CovidProject.dbo.CovidData
where continent is not null 
group by location
order by total_death_count desc




--death count per continent
select continent, max(cast(total_deaths as int)) as total_death_count
from CovidProject.dbo.CovidData
Where continent is not null 
Group by continent
order by total_death_count desc



--global numbers for cases and deaths
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_Cases)*100 as death_percentage
from CovidProject.dbo.CovidData
where continent is not null 
order by 1,2



--the number of people vaccinated per country
select continent, location, date, population, new_vaccinations, sum(convert(int, new_vaccinations)) over (partition by location order by date, date) as people_vaccinated
from CovidProject.dbo.CovidData
where continent is not null
order by 2,3


--percentage of population that has been vaccinated
With PopvsVac (continent, location, date, population, new_vaccinations, people_vaccinated)
as
(
select continent, location, date, population, new_vaccinations
, sum(convert(int,new_vaccinations)) over (partition by location order by location) as people_vaccinated
from CovidProject.dbo.CovidData
where continent is not null 
)
Select *, (people_vaccinated/population)*100
From PopvsVac



--using temp table to calculate on partitio
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
people_vaccinated numeric
)

insert into #PercentPopulationVaccinated
select continent, location, date, population, new_vaccinations
, sum(convert(int,new_vaccinations)) over (partition by location order by location, date) as people_vaccinated
from CovidProject.dbo.CovidData

select *, (people_vaccinated/population)*100
From #PercentPopulationVaccinated



--creating view to store data for later visualizations
create view PercentPopulationVaccinated as
select continent, location, date, population, new_vaccinations
, sum(convert(int,new_vaccinations)) over (partition by location order by location, date) as people_vaccinated
from CovidProject.dbo.CovidData
where continent is not null 