# 💧 Maji Ndogo Water Crisis: A Data Analysis Journey

> **Mission**: Transform 60,000+ survey records into actionable solutions for 27 million citizens facing a water crisis.

---

## 🌍 The Challenge

Maji Ndogo faces a critical infrastructure breakdown. Citizens wait up to 8 hours for water. Wells are contaminated. Home taps don't work. This project uses data science to chart a path from crisis to solution.

**Leadership Team:**
- 🎯 President Aziza Naledi - Executive Sponsor
- 📊 Chidi Kunto - Lead Data Analyst & Project Mentor

---

## 📁 Project Structure

```
maji-ndogo-analysis/
│
├── sql/
│   └── Maji_Ndogo_SQL_Solutions.sql    # Complete analysis queries
│
├── docs/
│   ├── Part_1_Slides.pdf               # Initial discovery phase
│   └── Part_2_Slides.pdf               # Strategic planning phase
│
└── README.md                            # You are here
```

---

## 🗄️ Data Architecture

### Core Tables

| Table | Purpose | Key Fields |
|-------|---------|------------|
| `water_source` | Water source inventory | type, people_served, source_id |
| `visits` | Field survey logs | queue_time, timestamp, employee_id |
| `location` | Geographic data | province, town, urban/rural flag |
| `water_quality` | Quality assessments | score (1-10), visit_count |
| `well_pollution` | Contamination tests | biological_ppm, chemical_ppm, results |
| `employee` | Staff directory | name, email, phone, town |

### Relationships
```
location ──┬─→ visits ──→ water_source
           │                    ↓
           └─→ water_quality    │
                                ↓
                          well_pollution
```

---

## 🔍 Phase 1: Discovery & Data Quality

### What We Found

#### 🚨 Critical Data Issues
1. **Misclassified wells**: 38 wells marked "Clean" despite biological contamination >0.01 CFU/mL
2. **Erroneous visits**: 218 home taps with perfect scores incorrectly revisited
3. **Description errors**: "Clean Bacteria: E. coli" contradictions in field notes

#### 📍 Geographic Insights
- 39,650 total water sources surveyed
- 60% rural, 40% urban distribution
- All 5 provinces proportionally represented

#### ⏱️ Queue Time Crisis
- **Extreme waits**: People queuing 500+ minutes (8+ hours)
- **Source**: Primarily shared taps serving 2,000+ people each
- **Zero waits**: Only home taps (when functional)

### Data Corrections Applied

```sql
-- Fixed 38 mislabeled contaminated wells
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = 'Clean';
```

---

## 📊 Phase 2: Deep Dive & Strategy

### Population Distribution Analysis

| Water Source Type | Population | % of Total | Avg. People/Source |
|-------------------|------------|------------|-------------------|
| 🚰 Shared Taps | 11.9M | 43% | 2,071 |
| 🕳️ Wells | 4.8M | 18% | 279 |
| 🏠 Home Taps (working) | 4.7M | 17% | 644 |
| 🔧 Home Taps (broken) | 3.8M | 14% | 649 |
| 🌊 Rivers | 2.4M | 9% | 699 |

*\*Actually ~6 people per household (data aggregated)*

### The Queue Time Story

**Survey conducted over 924 days (Jan 2021 - Jun 2023)**

#### Average Wait Times by Day
```
Monday    ████████████████ 137 min
Tuesday   ███████████ 108 min
Wednesday ██████████ 97 min    ← Shortest weekday
Thursday  ███████████ 105 min
Friday    ████████████ 120 min
Saturday  ████████████████████████ 246 min  ← Peak day!
Sunday    ████████ 82 min     ← Cultural minimum
```

#### Hourly Patterns
- **Peak Morning**: 6:00-8:00 AM (~150 min)
- **Mid-day Dip**: 11:00 AM-2:00 PM (~100 min)
- **Evening Rush**: 5:00-7:00 PM (~140 min)

#### Why Saturdays?
People collect their entire week's water supply on the weekend, creating massive bottlenecks at shared taps.

---

## 🎯 Strategic Intervention Plan

### Priority Matrix (Impact × Feasibility)

#### 🔴 TIER 1: Immediate Action (0-3 months)
**Target: 11.9M people using shared taps**

- Deploy water tankers to busiest locations
  - Saturdays + Monday mornings prioritized
  - Schedule based on pivot table analysis
- Install additional shared taps where queues >30 min
- Target: Reduce average wait from 120 min → <30 min (UN standard)

**Cost Estimate**: Medium | **Impact**: Very High

---

#### 🟠 TIER 2: Medium-term Fixes (3-12 months)
**Target: 4.8M people using wells (72% contaminated)**

- Install UV filters on biologically contaminated wells
- Install RO filters on chemically polluted wells
- Investigate contamination sources
- Repair 3.8M broken home tap infrastructure

**Cost Estimate**: High | **Impact**: High

---

#### 🟡 TIER 3: Long-term Solutions (1-3 years)
**Target: 2.4M people using rivers**

- Drill new wells in river-dependent communities
- Extend piped water networks to rural areas
- Install home taps in underserved regions
- Modernize aging treatment plants

**Cost Estimate**: Very High | **Impact**: Transformative

---

## 💻 Technical Implementation

### Key SQL Techniques Used

#### 1. Data Cleaning Pattern
```sql
-- Test on copy first
CREATE TABLE well_pollution_copy AS 
  SELECT * FROM well_pollution;

-- Apply changes
UPDATE well_pollution_copy SET ...;

-- Verify
SELECT * FROM well_pollution_copy 
WHERE [validation_condition];

-- Deploy & cleanup
UPDATE well_pollution SET ...;
DROP TABLE well_pollution_copy;
```

#### 2. Pivot Table in SQL
```sql
SELECT 
  TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Monday' 
    THEN time_in_queue ELSE NULL END), 0) AS Monday,
  ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Tuesday' 
    THEN time_in_queue ELSE NULL END), 0) AS Tuesday
  -- ... repeat for all days
FROM visits
WHERE time_in_queue != 0
GROUP BY hour
ORDER BY hour;
```

#### 3. Priority Ranking with Window Functions
```sql
SELECT 
  source_id,
  type_of_water_source,
  number_of_people_served,
  ROW_NUMBER() OVER (
    PARTITION BY type_of_water_source 
    ORDER BY number_of_people_served DESC
  ) AS priority_rank
FROM water_source
WHERE type_of_water_source != 'tap_in_home';
```

---

## 📈 Success Metrics

### Pre-Implementation Baseline
- ⏱️ Average queue time: **123 minutes**
- 🏚️ Non-functional home taps: **45%**
- 🧪 Contaminated wells: **72%**
- 🌊 River-dependent population: **2.4M**

### Target Outcomes (24 months)
- ⏱️ Average queue time: **<30 minutes** (UN standard)
- 🏚️ Non-functional home taps: **<15%**
- 🧪 Contaminated wells: **<20%**
- 🌊 River-dependent population: **<500K**

---

## 👥 Team Recognition

**Top 3 Field Surveyors** (by visits completed):
Identified using automated queries to celebrate exceptional performance over 924-day survey period.

---

## 🚀 Getting Started

### Prerequisites
- MySQL 5.7 or higher
- Access to `md_water_services` database

### Quick Start
```bash
# 1. Load the database
mysql -u username -p < database_dump.sql

# 2. Run analysis scripts
mysql -u username -p md_water_services < Maji_Ndogo_SQL_Solutions.sql

# 3. Export results for reporting
mysql -u username -p -e "SELECT * FROM [result_table]" > output.csv
```

---

## 📚 Key Learnings

### Data Quality Lessons
1. **Always validate**: Descriptions ≠ measurements
2. **Test before updating**: Copy tables for safety
3. **Document changes**: Comment your UPDATE statements

### Analysis Insights
1. **Context matters**: 644 people per "home tap" actually means aggregated households
2. **Percentages > raw numbers**: 43% is clearer than 11.9M
3. **Visualize patterns**: Pivot tables reveal weekly cycles

### Strategic Thinking
1. **Impact-first prioritization**: Fix what affects most people
2. **Quick wins exist**: Tanker deployment = immediate relief
3. **Infrastructure multiplier**: One treatment plant serves thousands

---

## 🔮 Future Enhancements

- [ ] Real-time queue monitoring system
- [ ] Mobile app for reporting broken infrastructure
- [ ] Predictive maintenance using historical data
- [ ] Cost-benefit analysis dashboard
- [ ] Community feedback integration

---

## 📞 Contact & Support

**Project Lead**: Chidi Kunto  
**Department**: Maji Ndogo Water Services  
**Email**: chidi.kunto@ndogowater.gov

**Report Issues**: Use MySQL query to identify your assigned_employee_id, then contact them directly.

---

## 📄 License & Attribution

**Data Source**: Maji Ndogo National Water Survey (2021-2023)  
**Analysis**: ExploreAI Academy Case Study  
**Status**: ✅ Analysis Complete | 🟡 Implementation Pending

---

> *"Mambo yatakuwa sawa" - Things will be okay.* 
> 
> — Chidi's mother

**Together, we will bring clean water to every citizen of Maji Ndogo.** 💧
