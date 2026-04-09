create database airline_db;
use airline_db;
create table flights (
    fl_date date,
    op_carrier varchar(10),
    origin varchar(10),
    dest varchar(10),
    dep_delay float,
    arr_delay float,
    cancelled int,
    cancellation_code varchar(5),
    crs_dep_time int,
    dep_time int,
    crs_arr_time int,
    arr_time int,
    carrier_delay float,
    weather_delay float,
    nas_delay float,
    security_delay float,
    late_aircraft_delay float,
    distance int
);
select * from flights limit 50;

-- 1. Manipulation Find the most delayed routes (origin-destination pairs). 
select origin, dest, avg(dep_delay) as avg_delay
from flights
where dep_delay is not null
group by origin, dest
order by avg_delay desc
limit 10;

-- 2. Calculate average delay per airline.
select op_carrier,
       avg(dep_delay) as avg_dep_delay,
       avg(arr_delay) as avg_arr_delay
from flights
group by op_carrier
order by avg_dep_delay desc;

-- 3. Retrieve total number of flights per airport.
select origin as airport, count(*) as total_flights
from flights
group by origin
order by total_flights desc;

-- 4. Count how many delays are due to weather, carrier, security, etc.
select sum(carrier_delay) as carrier_delay,
sum(weather_delay) as weather_delay,
sum(nas_delay) as nas_delay,
sum(security_delay) as security_delay,
sum(late_aircraft_delay) as late_aircraft_delay
from flights;

-- 5. Determine the average departure and arrival delay per month.
select month(fl_date) as month,
avg(dep_delay) as avg_dep_delay,
avg(arr_delay) as avg_arr_delay
from flights
group by month(fl_date)
order by month;

-- 6. Identify top 5 airports with the highest number of delayed departures.
select origin, count(*) as delayed_flights
from flights
where dep_delay > 0
group by origin
order by delayed_flights desc
limit 5;

-- 7. Get cancellation rate per airline.
select op_carrier,
count(*) as total_flights,
sum(cancelled) as cancelled_flights,
(sum(cancelled) * 100.0/count(*)) as cancelled_rate
from flights
group by op_carrier
order by cancelled_rate desc;
