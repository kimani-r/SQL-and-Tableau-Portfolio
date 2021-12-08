
select *
from CovidProject.dbo.CovidData


--queries used for the tableau project

--An overview of the Covid numbers worldwide
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from CovidProject.dbo.CovidData
where continent is not null
order by 1,2


--death counts per continent
select location, sum(cast(new_deaths as int)) as total_death_count
from CovidProject.dbo.CovidData
Where continent is null 
and location not in ('World', 'European Union', 'International', 'Low income', 'Upper middle income', 'High income', 'Lower middle income')
group by location
order by total_death_count desc


--the number of cases per country
Select location, population, max(total_cases) as highest_infection_count,  max((total_cases/population))*100 as percent_population_infected
from CovidProject.dbo.CovidData
group by location, population
order by percent_population_infected desc


--covid numbers per country
Select location, population,date, max(total_cases) as highest_infection_count,  max((total_cases/population))*100 as percent_population_infected
from CovidProject.dbo.CovidData
group by location, population, date
order by percent_population_infected desc


--see viz here: https://public.tableau.com/app/profile/kimani4678/viz/CovidProject1infectionanddeathnumbers/Dashboard1

