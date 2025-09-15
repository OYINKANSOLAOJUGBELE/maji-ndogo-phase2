-- Cleaning data
-- Update Employee Emails.
SELECT
  assigned_employee_id,
  employee_name,
  email,
  CONCAT(LOWER(REPLACE(TRIM(employee_name), ' ', '.')),
    '@ndogowater.gov') AS new_email
FROM employee
WHERE email IS NULL 
   OR email = ''
ORDER BY employee_name;

-- Create
CREATE table employee_update_table
SELECT *
FROM employee;

SET SQL_SAFE_UPDATES = 0;

UPDATE
	employee_update_table
SET email =  CONCAT(LOWER(REPLACE(TRIM(employee_name), ' ', '.')),
    '@ndogowater.gov');

-- 
  SELECT 
	employee_name,
    assigned_employee_id,
	TRIM(phone_number) AS phone_number
FROM employee;

UPDATE
	employee_update_table
SET phone_number = TRIM(phone_number);

-- Count employees in each town
SELECT
	town_name,
COUNT(*) AS employee_count
FROM employee
GROUP BY town_name;

SELECT
	province_name,
COUNT(*) AS employee_count
FROM employee
GROUP BY province_name;

-- Top 3 employee visits
SELECT 
    employee.assigned_employee_id,
    COUNT(visits.record_id) AS number_of_visits
FROM employee
JOIN visits
    ON employee.assigned_employee_id = visits.assigned_employee_id
GROUP BY employee.assigned_employee_id
ORDER BY number_of_visits
LIMIT 3;

-- Number of records per town
SELECT
	town_name,
    COUNT(*) AS record_town_count
FROM location
GROUP BY town_name;

-- Records per province
SELECT
	province_name,
    COUNT(*) AS record_province_count
FROM location
GROUP BY province_name;

--
SELECT 
	province_name,
    town_name,
    COUNT(*) AS record_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name DESC;

-- records per location type
SELECT
	location_type,
    COUNT(*) AS records_per_location_type
FROM location
GROUP BY location_type;

-- How many people were served
SELECT
  SUM(number_of_people_served)
FROM water_source;

--  How many wells, taps and rivers are there
SELECT
  type_of_water_source,
  COUNT(*)
FROM water_source
GROUP BY type_of_water_source;
  
  --  How many people share particular types of water sources on average
  SELECT
  type_of_water_source,
  AVG(number_of_people_served)
FROM water_source
GROUP BY type_of_water_source;

-- How many people are getting water from each type of source.
SELECT
  type_of_water_source,
  SUM(number_of_people_served)
FROM water_source
GROUP BY type_of_water_source;

-- Count of water sources
SELECT 
    type_of_water_source,
    COUNT(*) AS source_count
FROM water_source
GROUP BY type_of_water_source;

-- Average number of people serverd by each water source
SELECT
  type_of_water_source,
  ROUND(AVG(number_of_people_served), 2) AS average_people_per_source
FROM water_source
GROUP BY type_of_water_source;

-- total number of people served by each type of water source
SELECT
  type_of_water_source,
  SUM(number_of_people_served) AS population_served
FROM water_source
GROUP BY type_of_water_source;
  
  -- 
  SELECT
  type_of_water_source,
  ROUND(
    (SUM(number_of_people_served) / 27000000) * 100,
    2
  ) AS percentage_of_total_population
FROM water_source
GROUP BY
  type_of_water_source
ORDER BY
  percentage_of_total_population DESC;
  
  -- 
  SELECT
  type_of_water_source,
  ROUND(
    (SUM(number_of_people_served) / (SELECT SUM(number_of_people_served) FROM water_source)) * 100,
    0
  ) AS percentage_of_total
FROM water_source
GROUP BY
  type_of_water_source
ORDER BY
  percentage_of_total DESC;
  
  -- total people served column, converting it into a rank.
  SELECT
  type_of_water_source,
  total_people_served,
  RANK() OVER (
    ORDER BY total_people_served DESC
  ) AS rank_by_population
FROM (
  SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served
  FROM water_source
  GROUP BY
    type_of_water_source
) AS T1
ORDER BY
  rank_by_population;
  
  --  create a query to do this, and keep these requirements in mind:
 # The sources within each type should be assigned a rank.
 # Limit the results to only improvable sources.
 # Think about how to partition, filter and order the results set.
 # Order the results to see the top of the list.
SELECT
  source_id,
  type_of_water_source,
  number_of_people_served,
RANK() OVER (
    PARTITION BY type_of_water_source
    ORDER BY number_of_people_served DESC
  ) AS priority_rank
FROM
  water_source
WHERE
  type_of_water_source IN ('shared_tap', 'tap_in_home_broken', 'well', 'river', 'tap_in_home')
ORDER BY
  type_of_water_source,
  priority_rank;
  
  -- Different ranking functions
  SELECT
  source_id,
  type_of_water_source,
  number_of_people_served,
  ROW_NUMBER() OVER (
    PARTITION BY type_of_water_source
    ORDER BY number_of_people_served DESC
  ) AS rank_priority
FROM
  water_source
WHERE
  type_of_water_source IN ('shared_tap', 'tap_in_home_broken', 'well', 'river')
ORDER BY
  type_of_water_source,
  rank_priority;
  
  SELECT
  source_id,
  type_of_water_source,
  number_of_people_served,
  RANK() OVER (
    PARTITION BY type_of_water_source
    ORDER BY number_of_people_served DESC
  ) AS rank_priority
FROM
  water_source
WHERE
  type_of_water_source IN ('shared_tap', 'tap_in_home_broken', 'well', 'river')
ORDER BY
  type_of_water_source,
  rank_priority;
  
  SELECT
  source_id,
  type_of_water_source,
  number_of_people_served,
  DENSE_RANK() OVER (
    PARTITION BY type_of_water_source
    ORDER BY number_of_people_served DESC
  ) AS dense_ranking
FROM
  water_source
WHERE
  type_of_water_source IN ('shared_tap', 'tap_in_home_broken', 'well', 'river')
ORDER BY
  type_of_water_source,
  dense_ranking;
  
  --  How long the survey took
  SELECT
  DATEDIFF(
    MAX(time_of_record),
    MIN(time_of_record)
  ) AS survey_duration_days
FROM
  visits;
  
  --  average total queue time for water
  SELECT
  AVG(NULLIF(time_in_queue, 0)) AS avg_time_in_queue
FROM
  visits;

--  average queue time on different days
SELECT
  DAYNAME(time_of_record) AS day_of_week,
  AVG(time_in_queue) AS average_queue_time
FROM
  visits
GROUP BY
  day_of_week;
  
  -- what time during the day people collect water
  SELECT
  TIME_FORMAT(time(time_of_record), '%H:00') AS hour_of_day,
  COUNT(*) AS number_of_visits
FROM
  visits
GROUP BY
  hour_of_day;

SELECT
  TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
  AVG(time_in_queue) AS average_queue_time
FROM
  visits
GROUP BY
  hour_of_day;

-- 
 SELECT
 TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
 DAYNAME(time_of_record),
 CASE
 WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
 ELSE NULL
 END AS Sunday
 FROM
 visits
 WHERE
 time_in_queue != 0;
 
 SELECT
  TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
  ROUND(AVG(
    CASE
      WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
      ELSE NULL
    END
  ), 0) AS Sunday
FROM
  visits
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;
  
  -- Query for the rest of the days
  SELECT
  TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue ELSE NULL END), 0) AS Monday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue ELSE NULL END), 0) AS Tuesday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue ELSE NULL END), 0) AS Wednesday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue ELSE NULL END), 0) AS Thursday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue ELSE NULL END), 0) AS Friday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue ELSE NULL END), 0) AS Saturday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue ELSE NULL END), 0) AS Sunday
FROM
  visits
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;
  
  -- INSIGHTS
-- Clean data first
#Everyone’s email now follows the same easy format: firstname.lastname@ndogowater.gov.
#Phone numbers were tidied so there are no extra spaces.

-- People on the ground
#You can now see how many employees live in each town and province.
#The three workers with the most recorded visits stand out as the busiest staff.

-- Where the records are
#Counts show how many water-related locations exist in every town, province, and location type.
#The survey itself stretched over a set number of days, so you know how long the data collection took.

-- Water sources and who they serve
#You know the total number of people using all the water sources combined.
#It’s clear how many wells, taps, and rivers there are, and how many people share each type.
#You can see which source types serve the biggest share of the roughly 27 million residents.

-- What to fix first
#Among sources that can be improved—like shared taps, broken home taps, wells, 
#and rivers—you have a ranking of which individual sources help the most people. Those should get attention first.

-- When people fetch water
#Average wait times are calculated, and they vary by day of the week.
#Hour-by-hour numbers show the busiest times of day for collecting water.


    
