# Maji Ndogo Water Crisis Analysis

A comprehensive SQL-based data analysis project examining the water infrastructure crisis in Maji Ndogo, a fictional country facing significant water access challenges.

## Project Overview

This project analyzes survey data collected over 2.5 years to understand water source distribution, usage patterns, and queue times across Maji Ndogo. The analysis aims to provide data-driven insights for prioritizing infrastructure improvements and resource allocation.

## Key Findings

### Water Source Distribution
- **43%** of citizens rely on shared taps (averaging 2,000 people per tap)
- **31%** have home tap infrastructure, but **45%** of these systems are non-functional
- **18%** use wells, with only **28%** being clean
- **60%** of water sources are located in rural communities

### Queue Times
- Average wait time: **120 minutes** (2 hours)
- Longest queues: **Saturdays** (up to 4+ hours)
- Peak times: Morning (6-8 AM) and evening (6-8 PM)
- Shortest queues: Sundays and Wednesdays

## Database Structure

The analysis uses five main tables:

- `location` - Geographic information (provinces, towns, location types)
- `water_source` - Water source types and user populations
- `visits` - Survey visit records with queue times
- `water_quality` - Quality assessments and scores
- `well_pollution` - Contamination test results
- `employee` - Field surveyor information

## Technical Highlights

### SQL Techniques Used
- **String manipulation**: `REPLACE()`, `LOWER()`, `CONCAT()`, `TRIM()`
- **Aggregation**: `COUNT()`, `SUM()`, `AVG()`, `ROUND()`
- **Window functions**: `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`
- **DateTime functions**: `DAYNAME()`, `HOUR()`, `TIME_FORMAT()`, `DATEDIFF()`
- **Conditional logic**: `CASE` statements for pivot table creation
- **Data cleaning**: Correcting mislabeled records and contamination results

### Advanced Analysis
- Created SQL pivot table to analyze queue times by hour and day of week
- Ranked water sources by population impact using window functions
- Calculated percentages and formatted results for clear communication

## Recommended Solutions

### Short-term Interventions
1. **Rivers**: Deploy water trucks immediately
2. **Shared taps**: Send tankers to busiest locations during peak times
3. **Contaminated wells**: Install UV and reverse osmosis filters

### Long-term Strategy
1. Prioritize shared tap improvements (highest population impact)
2. Drill new wells to replace river sources
3. Repair broken home tap infrastructure
4. Focus resources on rural areas where most sources are located

## Getting Started

### Prerequisites
- MySQL 5.7 or higher
- Database client (MySQL Workbench, DBeaver, or similar)

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/maji-ndogo-water-analysis.git

# Import the database (schema not included in this repo)
# Run the analysis script
mysql -u username -p database_name < Maji_Ndogo_SQL_Solutions.sql
```

## Files in This Repository

- `Maji_Ndogo_SQL_Solutions.sql` - Main analysis queries
- `Part 2 [Slides].pdf` - Detailed project documentation and findings
- `README.md` - This file

## Sample Queries

### Count water sources by type
```sql
SELECT 
    type_of_water_source,
    COUNT(*) as number_of_sources
FROM water_source
GROUP BY type_of_water_source
ORDER BY number_of_sources DESC;
```

### Average queue time by day of week
```sql
SELECT 
    DAYNAME(time_of_record) as day_of_week,
    ROUND(AVG(NULLIF(time_in_queue, 0)), 0) as avg_queue_time
FROM visits
WHERE time_in_queue != 0
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 
               'Thursday', 'Friday', 'Saturday', 'Sunday');
```

## Data Quality Improvements

The project identified and corrected several data quality issues:
- Updated employee email addresses to standardized format
- Trimmed trailing spaces from phone numbers
- Corrected mislabeled well pollution results
- Fixed contamination descriptions

## Impact Assessment

By prioritizing improvements based on population served:
1. Improving shared taps affects **11.9 million people** (43%)
2. Cleaning contaminated wells helps **4.8 million people** (18%)
3. Repairing home tap infrastructure benefits **3.8 million people** (14%)

---

*"Mambo yatakuwa sawa" - Things will be okay.*
