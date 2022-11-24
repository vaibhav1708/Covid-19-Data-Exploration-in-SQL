select * from Covid_Deaths order by 3,4
--Looking at the total no of cases and deaths 
select location, date, population, total_cases, new_cases, total_deaths 
from Covid_Deaths order by 1,2 




--Looking at the number of cases of different countries 
select location, date, population, total_cases, total_cases_per_million, 
(total_cases/population)*100 as Percentage_of_population_infected
from Covid_Deaths 
where location like '%India%'
order by 1,2





--Looking at the new cases of different countries per day
select location, date, population, total_cases, new_cases, new_cases_per_million  
from Covid_Deaths where location like '%India%'
order by 1,2





--Looking at the death percentage of the total population and the mortality rate in each country
select location, date, population, total_cases, total_deaths, new_deaths, (total_deaths/total_cases)*100 as Mortality_Rate,
(total_deaths/population)*100 as Death_Percentage from Covid_Deaths
where location like '%United_States%'
order by 1,2 








--Looking at the highest case count of each country and percentage of the total population infected in each country 
select location, population, max(total_cases) as Highest_case,
max((total_cases)/population)*100 as Percentage_people_infected 
from Covid_Deaths 
group by location, population
order by Percentage_people_infected desc





--Looking at the Highest deaths and the percentage of people died in each country
select location, population, max(total_deaths) as HighestDeathCount, 
max(total_deaths/population)*100 as Death_Percentage
from Covid_Deaths 
group by location, population order by location






--Looking at the highest case count in each continent
select continent, max(total_cases) as Total_number_of_cases,
max(total_deaths) as Total_Number_of_Deaths
from Covid_Deaths where continent is not null
group by continent order by Total_number_of_cases desc






--Total cases and total deaths count per day
select date, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths
from Covid_Deaths
group by date order by 1,2





select * from covid_vaccinations order by location, date

select * from covid_deaths as dth join covid_vaccinations as vacc
on dth.date = vacc.date and dth.location = vacc.location



--Looking at the vaccination numbers 
select dth.continent, dth.location, dth.date, dth.population, vacc.new_vaccinations, 
sum(new_vaccinations) over (Partition by dth.location
					order by dth.location, dth.date) as Total_no_of_People_Vaccinated
from Covid_Deaths as dth join Covid_Vaccinations as vacc 
on dth.date=vacc.date and dth.location=vacc.location
order by 2,3









--Using the newly created column 'Total_no_of_People_Vaccinated' we couldn't find the precentage of people vaccinated
--We can solve this issue by using CTEs and temp tables
--CTE
With Pop_vs_Vacc (continent, location, date, population, new_vaccinations, Total_no_of_People_Vaccinated)
as
(select dth.continent, dth.location, dth.date, dth.population, vacc.new_vaccinations,
sum(vacc.new_vaccinations) over (partition by dth.location order by dth.location, dth.date) as Total_no_of_People_Vaccinated
from Covid_Deaths as dth join Covid_Vaccinations as vacc 
on dth.date=vacc.date and dth.location=vacc.location 
) select *, (Total_no_of_People_Vaccinated/Population)*100
as PercentagePeopleVaccinated from Pop_vs_Vacc order by 2,3







--Temp Table
Drop table if exists PercentageOfVaccination
Create Table PercentageOfVaccination
(continent varchar(255),
location varchar(255),
date date,
population float,
new_vaccinations float,
Total_no_of_People_Vaccinated float
)
Insert into PercentageOfVaccination
select dth.continent, dth.location, dth.date, dth.population, vacc.new_vaccinations,
sum(vacc.new_vaccinations) over (partition by dth.location) as Total_no_of_People_Vaccinated
from Covid_Deaths as dth join Covid_Vaccinations as vacc 
on dth.date=vacc.date and dth.location=vacc.location

select *, (Total_no_of_People_Vaccinated/Population)*100 as PercentagePeopleVaccinated from PercentageOfVaccination
order by 2,3









