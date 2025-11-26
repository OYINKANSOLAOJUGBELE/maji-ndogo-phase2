# Maji Ndogo Water Crisis Analysis 💧

A comprehensive SQL-based data analysis project examining the water infrastructure crisis in Maji Ndogo, a fictional country facing significant water access challenges. This project demonstrates advanced SQL techniques, data cleaning, exploratory data analysis, and actionable insight generation for infrastructure planning.

[![SQL](https://img.shields.io/badge/SQL-MySQL-blue.svg)](https://www.mysql.com/)
[![Status](https://img.shields.io/badge/Status-Complete-success.svg)]()
[![License](https://img.shields.io/badge/License-Educational-orange.svg)]()

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Business Context](#business-context)
- [Dataset Description](#dataset-description)
- [Key Findings](#key-findings)
- [Technical Analysis](#technical-analysis)
- [SQL Techniques Demonstrated](#sql-techniques-demonstrated)
- [Installation & Setup](#installation--setup)
- [Query Examples](#query-examples)
- [Visualizations](#visualizations)
- [Recommendations](#recommendations)
- [Project Structure](#project-structure)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Project Overview

This project analyzes a comprehensive water source survey conducted over **924 days (2.5 years)** across Maji Ndogo. The analysis involves:

- **27+ million citizens** surveyed
- **60,000+ water sources** documented
- **Multiple provinces and towns** covered
- **Real-time queue monitoring** at shared water sources
- **Water quality testing** for contamination

### Objectives

1. **Identify** water source distribution and accessibility patterns
2. **Analyze** queue times and citizen water collection behavior
3. **Prioritize** infrastructure improvements based on population impact
4. **Provide** actionable recommendations for government intervention
5. **Estimate** resource requirements for water crisis resolution

## 🌍 Business Context

Maji Ndogo is experiencing a severe water crisis affecting millions of citizens. The government, led by President Aziza Naledi, commissioned a comprehensive survey to:

- Document all water sources across the country
- Understand citizen access patterns and challenges
- Identify contaminated sources
- Guide resource allocation for infrastructure improvements

### Stakeholders

- **President Aziza Naledi**: Project sponsor and decision-maker
- **Chidi Kunto**: Lead data analyst and project coordinator
- **Field Surveyors**: 60+ employees conducting on-ground assessments
- **Engineering Teams**: Infrastructure repair and installation crews
- **Citizens of Maji Ndogo**: 27 million beneficiaries

## 📊 Dataset Description

### Database Schema

The analysis uses a relational database with the following tables:

#### 1. `location` Table
```
location_id (PK)
├── address
├── province_name
├── town_name
├── location_type (Urban/Rural)
└── total_records: 39,650
```

#### 2. `water_source` Table
```
source_id (PK)
├── type_of_water_source
│   ├── tap_in_home (7,265 sources)
│   ├── tap_in_home_broken (5,856 sources)
│   ├── shared_tap (6,918 sources)
│   ├── well (17,383 sources)
│   └── river (3,382 sources)
├── location_id (FK)
└── number_of_people_served
```

#### 3. `visits` Table
```
record_id (PK)
├── location_id (FK)
├── source_id (FK)
├── assigned_employee_id (FK)
├── time_of_record (DateTime)
├── time_in_queue (minutes)
└── visit_count
```

#### 4. `water_quality` Table
```
record_id (PK)
├── source_id (FK)
├── visit_count
├── subjective_quality_score (1-10)
└── quality_assessment
```

#### 5. `well_pollution` Table
```
source_id (PK, FK)
├── description
├── biological (contamination level)
├── results
│   ├── Clean
│   ├── Contaminated: Biological
│   └── Contaminated: Chemical
└── affected_wells: 12,467 (72%)
```

#### 6. `employee` Table
```
assigned_employee_id (PK)
├── employee_name
├── email
├── phone_number
├── position
└── town_name
```

## 🔍 Key Findings

### Water Source Distribution

#### By Type
| Water Source Type | Count | % of Total | Population Served | % of Population |
|------------------|-------|-----------|-------------------|----------------|
| Shared Tap | 6,918 | 17% | 11,945,272 | 43% |
| Well | 17,383 | 43% | 4,841,724 | 18% |
| Tap in Home | 7,265 | 18% | 4,678,880 | 17% |
| Tap in Home (Broken) | 5,856 | 14% | 3,799,720 | 14% |
| River | 3,382 | 8% | 2,362,544 | 9% |

#### By Location Type
- **Rural**: 23,740 sources (60%)
- **Urban**: 15,910 sources (40%)

#### By Province
| Province | Number of Sources |
|----------|------------------|
| Kilimani | 9,510 |
| Akatsi | 8,940 |
| Sokoto | 8,220 |
| Amanzi | 6,950 |
| Hawassa | 6,030 |

### Critical Issues Identified

#### 1. Shared Tap Overcrowding
- **Average users per tap**: 2,071 people
- **UN Standard**: Maximum 30-minute wait time
- **Current average**: 120 minutes (4x the standard)
- **Impact**: 11.9 million people (43% of population)

#### 2. Broken Home Infrastructure
- **31%** of population has home tap infrastructure
- **45%** of home taps are non-functional
- **Root causes**: Broken pipes, pumps, treatment plants, reservoirs
- **Impact**: 3.8 million people without reliable water

#### 3. Well Contamination
- **Total wells**: 17,383
- **Clean wells**: 4,916 (28%)
- **Contaminated wells**: 12,467 (72%)
  - Biological contamination: E. coli, Giardia Lamblia
  - Chemical pollution: Industrial/agricultural runoff
- **Impact**: 4.8 million people at risk

#### 4. River Dependency
- **2.4 million people** still collecting water from rivers
- **Health risks**: Waterborne diseases, parasites
- **Distance**: Often requires long travel times
- **Priority**: Immediate intervention required

### Queue Time Analysis

#### Overall Statistics
- **Average queue time**: 123 minutes (2+ hours)
- **Survey duration**: 924 days (2.5 years)
- **Peak wait times**: Up to 500+ minutes (8+ hours)

#### By Day of Week
| Day | Average Queue Time (min) |
|-----|-------------------------|
| Saturday | 246 ⚠️ |
| Monday | 137 |
| Friday | 120 |
| Tuesday | 108 |
| Thursday | 105 |
| Wednesday | 97 |
| Sunday | 82 |

#### By Time of Day
| Time Period | Average Queue Time |
|------------|-------------------|
| 06:00-08:00 | 149 min (Peak AM) |
| 09:00-11:00 | 105 min |
| 12:00-14:00 | 89 min |
| 15:00-17:00 | 98 min |
| 18:00-20:00 | 145 min (Peak PM) |

#### Key Patterns
1. **Saturday Crisis**: Queue times double on Saturdays (families stockpiling water for the week)
2. **Rush Hours**: Mornings (before work) and evenings (after work) see longest queues
3. **Cultural Impact**: Sundays have shortest queues (family/religious day)
4. **Mid-week Relief**: Wednesday shows lowest average wait times

## 🔬 Technical Analysis

### Phase 1: Data Cleaning & Preparation

#### Employee Data Updates
```sql
-- Generate standardized email addresses
UPDATE employee
SET email = CONCAT(
    LOWER(REPLACE(employee_name, ' ', '.')), 
    '@ndogowater.gov'
);

-- Clean phone numbers (remove trailing spaces)
UPDATE employee
SET phone_number = TRIM(phone_number);

-- Verification
SELECT 
    employee_name,
    email,
    LENGTH(phone_number) as phone_length
FROM employee
LIMIT 5;
```

**Results**: 
- ✅ 60+ employee emails standardized
- ✅ Phone numbers corrected to 12 characters (+99XXXXXXXXX)

#### Well Pollution Data Correction

**Problem Identified**: Wells marked as "Clean" despite biological contamination > 0.01

```sql
-- Find misclassified wells
SELECT *
FROM well_pollution
WHERE results = 'Clean'
  AND biological > 0.01;
-- Result: 38 wells incorrectly classified

-- Fix descriptions
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

-- Fix results classification
UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = 'Clean';
```

**Impact**: Corrected classification of 38 contaminated wells, ensuring accurate intervention planning.

### Phase 2: Employee Performance Analysis

#### Top Field Surveyors

```sql
-- Identify top 3 surveyors by location visits
SELECT 
    e.assigned_employee_id,
    e.employee_name,
    e.email,
    e.phone_number,
    COUNT(v.location_id) as number_of_visits
FROM employee e
JOIN visits v ON e.assigned_employee_id = v.assigned_employee_id
GROUP BY e.assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;
```

**Top Performers**:
1. Employee ID 1: 3,708 visits
2. Employee ID 2: 2,033 visits  
3. Employee ID 30: 1,099 visits

#### Employee Distribution by Town

```sql
SELECT 
    town_name,
    COUNT(*) as num_employees
FROM employee
GROUP BY town_name
ORDER BY num_employees DESC;
```

**Key Insight**: 29 employees based in rural areas, reflecting the distribution of water sources.

### Phase 3: Location Analysis

#### Records by Province and Town

```sql
SELECT 
    province_name,
    town_name,
    COUNT(*) as records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;
```

**Sample Results**:
```
Akatsi    | Rural    | 6,290
Akatsi    | Lusaka   | 1,070
Akatsi    | Harare   | 800
Amanzi    | Rural    | 3,100
Amanzi    | Asmara   | 930
```

#### Location Type Distribution

```sql
SELECT 
    location_type,
    COUNT(*) as num_sources,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM location), 1) as percentage
FROM location
GROUP BY location_type;
```

**Results**:
- Rural: 23,740 (60%)
- Urban: 15,910 (40%)

**Strategic Implication**: Infrastructure improvements must account for rural logistics challenges (roads, supplies, labor).

### Phase 4: Water Source Deep Dive

#### Total Population Surveyed

```sql
SELECT 
    FORMAT(SUM(number_of_people_served), 0) as total_population
FROM water_source;
```

**Result**: 27,628,140 citizens surveyed

#### Water Source Type Analysis

```sql
-- Count by type
SELECT 
    type_of_water_source,
    COUNT(*) as number_of_sources,
    FORMAT(SUM(number_of_people_served), 0) as population_served,
    ROUND(SUM(number_of_people_served) * 100.0 / 
          (SELECT SUM(number_of_people_served) FROM water_source), 0) 
          as percentage
FROM water_source
GROUP BY type_of_water_source
ORDER BY population_served DESC;
```

#### Average Users per Source Type

```sql
SELECT 
    type_of_water_source,
    ROUND(AVG(number_of_people_served), 0) as ave_people_per_source
FROM water_source
GROUP BY type_of_water_source
ORDER BY ave_people_per_source DESC;
```

**Critical Finding**: 
- Shared taps: 2,071 people per source ⚠️
- Rivers: 699 people per source
- Tap in home: 644 people per source*
- Wells: 279 people per source

*Note: Home taps were grouped by surveyors (644 ÷ 6 people per household = ~107 actual taps)

### Phase 5: Infrastructure Priority Ranking

#### Ranking by Population Impact

```sql
SELECT 
    type_of_water_source,
    SUM(number_of_people_served) as people_served,
    RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) as rank_by_population
FROM water_source
WHERE type_of_water_source != 'tap_in_home'  -- Already optimal
GROUP BY type_of_water_source;
```

**Priority Order**:
1. Shared Tap (11.9M people) - Rank 1
2. Well (4.8M people) - Rank 2
3. Tap in Home Broken (3.8M people) - Rank 3
4. River (2.4M people) - Rank 4

#### Source-Level Priority Ranking

```sql
SELECT 
    source_id,
    type_of_water_source,
    number_of_people_served,
    ROW_NUMBER() OVER (
        PARTITION BY type_of_water_source 
        ORDER BY number_of_people_served DESC
    ) as priority_rank
FROM water_source
WHERE type_of_water_source IN ('shared_tap', 'well', 'river', 'tap_in_home_broken')
ORDER BY type_of_water_source, priority_rank;
```

**Usage**: Engineering teams can use this ranking to prioritize which specific sources to repair first.

### Phase 6: Queue Time Analysis

#### Survey Duration

```sql
SELECT 
    DATEDIFF(MAX(time_of_record), MIN(time_of_record)) as survey_days,
    MIN(time_of_record) as survey_start,
    MAX(time_of_record) as survey_end
FROM visits;
```

**Result**: 924 days (Jan 2021 - Dec 2023)

#### Average Queue Time

```sql
SELECT 
    ROUND(AVG(NULLIF(time_in_queue, 0)), 0) as avg_queue_minutes
FROM visits
WHERE time_in_queue > 0;
```

**Result**: 123 minutes (2 hours 3 minutes)

**Context**: This excludes home taps (queue = 0). Represents actual wait time at shared sources.

#### Queue Time by Day of Week

```sql
SELECT 
    DAYNAME(time_of_record) as day_of_week,
    ROUND(AVG(NULLIF(time_in_queue, 0)), 0) as avg_queue_time
FROM visits
WHERE time_in_queue > 0
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 
               'Wednesday', 'Thursday', 'Friday', 'Saturday');
```

#### Queue Time by Hour

```sql
SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') as hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue, 0)), 0) as avg_queue_time
FROM visits
WHERE time_in_queue > 0
GROUP BY HOUR(time_of_record)
ORDER BY HOUR(time_of_record);
```

### Phase 7: Advanced Pivot Table Analysis

#### Creating a SQL Pivot Table (Queue Times by Hour and Day)

This is the most complex query in the analysis, demonstrating advanced SQL techniques:

```sql
SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    
    -- Sunday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Sunday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Sunday,
    
    -- Monday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Monday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Monday,
    
    -- Tuesday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Tuesday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Tuesday,
    
    -- Wednesday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Wednesday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Wednesday,
    
    -- Thursday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Thursday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Thursday,
    
    -- Friday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Friday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Friday,
    
    -- Saturday
    ROUND(AVG(
        CASE WHEN DAYNAME(time_of_record) = 'Saturday' 
             THEN time_in_queue ELSE NULL END
    ), 0) AS Saturday
    
FROM visits
WHERE time_in_queue != 0
GROUP BY HOUR(time_of_record)
ORDER BY HOUR(time_of_record);
```

**Output Sample**:
| Hour | Sun | Mon | Tue | Wed | Thu | Fri | Sat |
|------|-----|-----|-----|-----|-----|-----|-----|
| 06:00 | 79 | 190 | 134 | 112 | 134 | 153 | 247 |
| 07:00 | 82 | 186 | 128 | 111 | 139 | 156 | 247 |
| 08:00 | 86 | 183 | 130 | 119 | 129 | 153 | 247 |
| 09:00 | 84 | 127 | 105 | 94 | 99 | 107 | 252 |
| 18:00 | 86 | 195 | 142 | 125 | 148 | 168 | 259 |

**Key Patterns Revealed**:
1. ⚠️ **Saturday mornings** (06:00-11:00): Consistently 240+ minutes
2. 📈 **Monday rush**: 190-min queues at 6 AM (weekly stockpiling)
3. ⏰ **Peak hours**: 6-8 AM and 6-8 PM across all weekdays
4. ✅ **Best times**: Sundays (religious/family day), Wednesday afternoons

## 🛠️ SQL Techniques Demonstrated

### String Manipulation
- `REPLACE()` - Remove/replace characters
- `LOWER()` / `UPPER()` - Case conversion
- `CONCAT()` - String concatenation
- `TRIM()` - Remove whitespace
- `LENGTH()` - String length

### Aggregate Functions
- `COUNT()` - Row counting
- `SUM()` - Total calculations
- `AVG()` - Average calculations
- `ROUND()` - Decimal precision control
- `FORMAT()` - Number formatting with commas
- `MIN()` / `MAX()` - Extreme value finding

### Window Functions
- `RANK()` - Ranking with gaps
- `DENSE_RANK()` - Ranking without gaps
- `ROW_NUMBER()` - Unique sequential numbering
- `PARTITION BY` - Grouped window calculations
- `ORDER BY` within windows

### DateTime Functions
- `DAYNAME()` - Extract day name
- `HOUR()` - Extract hour
- `TIME()` - Extract time component
- `TIME_FORMAT()` - Custom time formatting
- `DATEDIFF()` - Calculate date differences

### Conditional Logic
- `CASE WHEN` - Conditional expressions
- `NULLIF()` - Convert values to NULL
- `IF()` - Simple conditionals

### Joins & Relationships
- `INNER JOIN` - Matching records
- `LEFT JOIN` - Include all left records
- Foreign key relationships

### Data Modification
- `UPDATE ... SET` - Modify existing records
- `WHERE` clauses for targeted updates

### Advanced Techniques
- **Pivot tables**: Using CASE statements to transform rows to columns
- **Subqueries**: Nested SELECT statements for complex calculations
- **Grouping**: Multi-level GROUP BY with multiple dimensions
- **Custom sorting**: FIELD() function for non-alphabetical ordering

## 📝 Query Examples

### Example 1: Find Most Contaminated Towns

```sql
SELECT 
    l.town_name,
    l.province_name,
    COUNT(wp.source_id) as contaminated_wells,
    ROUND(COUNT(wp.source_id) * 100.0 / 
          (SELECT COUNT(*) FROM well_pollution WHERE results LIKE 'Contaminated%'), 2) 
          as pct_of_total
FROM location l
JOIN water_source ws ON l.location_id = ws.location_id
JOIN well_pollution wp ON ws.source_id = wp.source_id
WHERE wp.results LIKE 'Contaminated%'
GROUP BY l.town_name, l.province_name
ORDER BY contaminated_wells DESC
LIMIT 10;
```

### Example 2: Identify Extreme Queue Times

```sql
SELECT 
    v.record_id,
    l.town_name,
    l.province_name,
    ws.type_of_water_source,
    v.time_in_queue,
    DAYNAME(v.time_of_record) as day,
    TIME_FORMAT(TIME(v.time_of_record), '%H:%i') as time
FROM visits v
JOIN location l ON v.location_id = l.location_id
JOIN water_source ws ON v.source_id = ws.source_id
WHERE v.time_in_queue > 300  -- More than 5 hours
ORDER BY v.time_in_queue DESC
LIMIT 20;
```

### Example 3: Water Source Quality Dashboard

```sql
SELECT 
    ws.type_of_water_source,
    COUNT(DISTINCT ws.source_id) as total_sources,
    SUM(ws.number_of_people_served) as people_served,
    ROUND(AVG(wq.subjective_quality_score), 2) as avg_quality_score,
    ROUND(AVG(NULLIF(v.time_in_queue, 0)), 0) as avg_queue_time
FROM water_source ws
LEFT JOIN water_quality wq ON ws.source_id = wq.source_id
LEFT JOIN visits v ON ws.source_id = v.source_id
GROUP BY ws.type_of_water_source
ORDER BY people_served DESC;
```

### Example 4: Employee Performance Metrics

```sql
SELECT 
    e.employee_name,
    e.town_name as based_in,
    COUNT(DISTINCT v.location_id) as locations_visited,
    COUNT(v.record_id) as total_visits,
    ROUND(AVG(v.time_in_queue), 0) as avg_queue_observed,
    DATEDIFF(MAX(v.time_of_record), MIN(v.time_of_record)) as days_active
FROM employee e
JOIN visits v ON e.assigned_employee_id = v.assigned_employee_id
GROUP BY e.assigned_employee_id
ORDER BY locations_visited DESC;
```

### Example 5: Provincial Water Crisis Index

```sql
WITH province_stats AS (
    SELECT 
        l.province_name,
        COUNT(DISTINCT ws.source_id) as total_sources,
        SUM(ws.number_of_people_served) as population,
        SUM(CASE WHEN ws.type_of_water_source = 'river' THEN ws.number_of_people_served ELSE 0 END) as river_dependent,
        SUM(CASE WHEN wp.results LIKE 'Contaminated%' THEN ws.number_of_people_served ELSE 0 END) as contaminated_well_users,
        AVG(NULLIF(v.time_in_queue, 0)) as avg_queue_time
    FROM location l
    JOIN water_source ws ON l.location_id = ws.location_id
    LEFT JOIN well_pollution wp ON ws.source_id = wp.source_id
    LEFT JOIN visits v ON ws.source_id = v.source_id
    GROUP BY l.province_name
)
SELECT 
    province_name,
    FORMAT(population, 0) as total_population,
    ROUND((river_dependent + contaminated_well_users) * 100.0 / population, 1) as pct_at_risk,
    ROUND(avg_queue_time, 0) as avg_wait_minutes,
    -- Simple crisis index (higher = worse)
    ROUND(
        (river_dependent * 3 + contaminated_well_users * 2) * avg_queue_time / population,
        2
    ) as crisis_index
FROM province_stats
ORDER BY crisis_index DESC;
```

## 💡 Recommendations

### Immediate Actions (0-3 months)

#### 1. Emergency Water Delivery 🚚
**Target**: River-dependent communities (2.4M people)

```sql
-- Identify top priority locations
SELECT 
    l.province_name,
    l.town_name,
    l.address,
    ws.number_of_people_served,
    'River' as current_source,
    'Deploy water truck' as action
FROM location l
JOIN water_source ws ON l.location_id = ws.location_id
WHERE ws.type_of_water_source = 'river'
ORDER BY ws.number_of_people_served DESC
LIMIT 50;
```

**Action Items**:
- Deploy 50+ water tanker trucks
- Prioritize locations serving 500+ people
- Daily water delivery schedule
- **Cost estimate**: $2M-3M/month

#### 2. Saturday Peak Management 📅
**Target**: Shared taps with extreme Saturday queues

```sql
-- Find shared taps with Saturday crisis
SELECT 
    v.source_id,
    l.town_name,
    l.address,
    AVG(CASE WHEN DAYNAME(v.time_of_record) = 'Saturday' 
             THEN v.time_in_queue END) as saturday_avg
FROM visits v
JOIN location l ON v.location_id = l.location_id
JOIN water_source ws ON v.source_id = ws.source_id
WHERE ws.type_of_water_source = 'shared_tap'
GROUP BY v.source_id
HAVING saturday_avg > 180
ORDER BY saturday_avg DESC;
```

**Action Items**:
- Deploy mobile water tanks to 100 busiest locations
- Saturday-only supplementary service
-Operate 5AM-2PM (peak period)
- **Cost estimate**: $500K/month

#### 3. Well Filter Installation 🔬
**Target**: Contaminated wells (12,467 sources)

**Priority Ranking**:
```sql
SELECT 
    wp.source_id,
    l.province_name,
    l.town_name,
    ws.number_of_people_served,
    wp.biological,
    CASE 
        WHEN wp.biological > 0.01 THEN 'UV Filter'
        WHEN wp.results LIKE '%Chemical%' THEN 'Reverse Osmosis'
    END as filter_type
FROM well_pollution wp
JOIN water_source ws ON wp.source_id = ws.source_id
JOIN location l ON ws.location_id = l.location_id
WHERE wp.results LIKE 'Contaminated%'
ORDER BY ws.number_of_people_served DESC;
```

**Action Items**:
- Install UV filters: $150 per well × 10,000 wells = $1.5M
- Install RO systems: $500 per well × 2,467 wells = $1.2M
- 50 wells/day installation rate
- **Timeline**: 8-9 months
- **Total cost**: $2.7M

### Short-term Improvements (3-12 months)

#### 4. Shared Tap Expansion 🚰
**Target**: Reduce queue times below 30 minutes (UN standard)

**Calculation Model**:
```sql
WITH tap_analysis AS (
    SELECT 
        source_id,
        number_of_people_served,
        number_of_people_served / 2071 as current_taps,  -- avg people per tap
        CEIL(number_of_people_served / 600.0) as needed_taps,  -- target 600 people per tap
        CEIL(number_of_people_served / 600.0) - (number_of_people_served / 2071) as additional_taps
    FROM water_source
    WHERE type_of_water_source = 'shared_tap'
)
SELECT 
    SUM(additional_taps) as total_new_taps_needed,
    SUM(additional_taps) * 1500 as estimated_cost_usd
FROM tap_analysis;
```

**Action Items**:
- Install ~8,000 additional public taps
- Cost: $1,500 per tap installation
- **Total cost**: $12M
- **Timeline**: 12 months (22 taps/day)

#### 5. Well Drilling Program ⛏️
**Target**: Replace all river sources

**Requirements**:
- 3,382 new wells needed
- $5,000 per well (drilling + testing)
- **Total cost**: $16.9M
- **Timeline**: 18 months

#### 6. Broken Infrastructure Repair 🔧
**Target**: 5,856 broken home taps (3.8M people)

```sql
-- Identify infrastructure clusters
SELECT 
    l.town_name,
    l.province_name,
    COUNT(*) as broken_taps,
    SUM(ws.number_of_people_served) as people_affected
FROM water_source ws
JOIN location l ON ws.location_id = l.location_id
WHERE ws.type_of_water_source = 'tap_in_home_broken'
GROUP BY l.town_name, l.province_name
HAVING broken_taps > 50
ORDER BY people_affected DESC;
```

**Strategy**:
- Focus on towns with 50+ broken taps (shared infrastructure issue)
- Repair treatment plants, pipes, pumps, reservoirs
- **High-impact repairs**: Fix 1 plant → restore 1,000+ taps
- **Cost estimate**: $25M (infrastructure rehab)
- **Timeline**: 18-24 months

### Long-term Strategy (1-3 years)

#### 7. Home Tap Installation Program 🏠
**Target**: Rural communities currently using shared taps

**Phased Approach**:
- **Phase 1**: Towns with 20+ shared taps
- **Phase 2**: Urban areas with high population density
- **Phase 3**: Remote rural communities

**Costs**:
- Household connection: $2,500 per home
- 100,000 homes targeted
- **Total**: $250M (seek international funding)

#### 8. Water Quality Monitoring System 📡
**Implementation**:
- IoT sensors on all sources
- Real-time contamination alerts
- Automated reporting to health officials
- **Cost**: $5M setup + $1M/year maintenance

#### 9. Infrastructure Maintenance Program 🔄
**Prevention Strategy**:
- Regular inspections (quarterly)
- Preventive maintenance schedule
- Community training for basic repairs
- **Annual budget**: $8M

### Success Metrics & KPIs

```sql
-- Dashboard Query for Progress Tracking
SELECT 
    'Average Queue Time' as metric,
    CONCAT(ROUND(AVG(NULLIF(time_in_queue, 0)), 0), ' min') as current_value,
    '< 30 min' as target,
    CASE WHEN AVG(NULLIF(time_in_queue, 0)) > 30 THEN '🔴' ELSE '🟢' END as status
FROM visits
UNION ALL
SELECT 
    'Clean Well %',
    CONCAT(ROUND(SUM(CASE WHEN results = 'Clean' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1), '%'),
    '> 80%',
    CASE WHEN SUM(CASE WHEN results = 'Clean' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) < 80 THEN '🔴' ELSE '🟢' END
FROM well_pollution
UNION ALL
SELECT 
    'People with Home Taps',
    CONCAT(ROUND(SUM(CASE WHEN type_of_water_source = 'tap_in_home' THEN number_of_people_served ELSE 0 END) * 100.0 / 
           SUM(number_of_people_served), 1), '%'),
    '> 60%',
    CASE WHEN SUM(CASE WHEN type_of_water_source = 'tap_in_home' THEN number_of_people_served ELSE 0 END) * 100.0 / 
              SUM(number_of_people_served) < 60 THEN '🔴' ELSE '🟢' END
FROM water_source;
```

## 📁 Project Structure

```
maji-ndogo-water-analysis/
│
├── README.md                          # This file
├── LICENSE                            # Project license
│
├── sql/
│   ├── Maji_Ndogo_SQL_Solutions.sql  # Main analysis queries
│   ├── 01_data_cleaning.sql          # Data cleaning scripts
│   ├── 02_employee_analysis.sql      # Employee performance queries
│   ├── 03_location_analysis.sql      # Geographic analysis
│   ├── 04_water_source_analysis.sql  # Water source deep dive
│   ├── 05_queue_analysis.sql         # Queue time analysis
│   ├── 06_priority_ranking.sql       # Infrastructure prioritization
│   └── 07_dashboard_queries.sql      # KPI and monitoring queries
│
├── data/
│   ├── schema.sql                    # Database schema (if available)
│   ├── sample_data.sql               # Sample data for testing
│   └── data_dictionary.md            # Column descriptions
│
├── docs/
│   ├── Part_2_Slides.pdf             # Project presentation
│   ├── methodology.md                # Analysis methodology
│   ├── findings_report.md            # Detailed findings
│   └── recommendations.md            # Action plan details
│
├── visualizations/
│   ├── queue_heatmap.png             # Queue time visualization
│   ├── water_source_distribution.png # Source type breakdown
│   ├── provincial_comparison.png     # Province-level metrics
│   └── python_viz_code.py            # Visualization scripts
│
└── scripts/
    ├── export_to_csv.sh              # Data export utilities
    ├── backup_database.sh            # Backup scripts
    └── performance_test.sql          # Query optimization tests
```

## 📚 Learning Resources

### SQL Concepts Used
- [Window Functions](https://www.postgresql.org/docs/current/tutorial-window.html)
- [DateTime Functions](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html)
- [Pivot Tables in SQL](https://www.sqlshack.com/multiple-options-to-transposing-rows-into-columns/)
- [String Functions](https://dev.mysql.com/doc/refman/8.0/en/string-functions.html)

### Related Topics
- Water infrastructure management
- Public health data analysis
- Geographic Information Systems (GIS)
- Development economics

## 🙏 Acknowledgments

- **ExploreAI Academy**: For the case study framework and educational materials
- **President Aziza Naledi**: Project sponsor (fictional)
- **Field Surveyors**: 60+ employees who collected this data over 2.5 years
- **Open Source Community**: For SQL tools and resources

### Inspiration

This project reflects real-world water crises faced by communities globally:
- **Sub-Saharan Africa**: 400M+ people lack basic water access
- **WHO Standards**: Maximum 30-minute collection time
- **UN SDG 6**: Clean water and sanitation for all by 2030

## 📄 License

This project is licensed for educational purposes. Please do not copy without permission.

## 🌟 Star This Repo

If you found this analysis helpful, please consider starring the repository!

---

### Final Note

> *"Mambo yatakuwa sawa"* - Things will be okay.
> 
> This analysis represents more than just SQL queries and data points. Each number represents a person—a child walking kilometers for water, a mother spending hours in queue, a family struggling with contaminated sources.
> 
> Data analysis has the power to change lives when converted into action. This project demonstrates how technical skills can drive meaningful social impact.

**Last Updated**: November 2024  
**Version**: 2.0  
**Status**: ✅ Analysis Complete | 🚧 Implementation Pending
