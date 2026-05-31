# 🚕 Urban Mobility Intelligence Platform

> End-to-end ride-share analytics platform analysing 30M+ real NYC trips to surface operational insights and product recommendations.

## 📊 Live Dashboard

👉 **[View Interactive Dashboard on Tableau Public](https://public.tableau.com/app/profile/rakshitha.ravishankar/viz/urbanmobility_17801925970410/UrbanMobilityIntelligenceNYCRide-ShareAnalytics)**

![Demand Heatmap](dashboard/demand_heatmap.png)

---

## 📌 Executive Summary

This project analyses 30 million+ real NYC taxi and ride-share trips from 2022 using a production-style analytics stack (BigQuery, dbt, Python, Tableau, AI). The central finding: **peak hours (5–6pm Tue–Thu) drive 72% of all revenue despite covering less than 20% of daily hours** — representing the single highest-ROI operational lever for any ride-share platform. Four specific, quantified recommendations are provided for product and operations teams.

---

## 🔍 Key Findings

**1. Peak hours drive 72% of all revenue**
- Rush hour (7–9am, 5–7pm) generates $549M vs $209M off-peak
- Recommendation: prioritise driver supply incentives during peak windows to protect the revenue-critical hours

**2. NYC ride-share recovered strongly in early 2022**
- Feb and Mar 2022 saw +21% MoM growth — post-COVID demand surge
- Oct 2022 hit peak revenue at $80M — fall return-to-office effect
- Jul 2022 dipped -10.8% — summer exodus pattern, predictable annually

**3. Short trips dominate volume but long trips dominate fare**
- Trips under 5 miles = 60% of all trips but lower avg fare ($7–14)
- Airport/long haul trips avg $46+ fare — 6x higher revenue per trip
- JFK Airport (Zone 132) alone generated **$102M** from one pickup zone
- Recommendation: dedicated airport supply positioning strategy

**4. Evening rush riders tip the most (19%)**
- Evening rush has highest tip rate despite high volume
- Off-peak riders tip 11.6% — still meaningful at 9.7M trips
- Recommendation: driver satisfaction programs should highlight evening rush earnings potential

**5. Monthly volume follows a strong and predictable recovery arc**
- January 2022 started at 2.4M trips — by March reached 3.6M (+50% in 2 months)
- Stabilised through summer, then peaked at 3.6M again in October
- V-shaped recovery pattern suggests demand is structurally healthy and seasonal dips are temporary

---

## 💡 Business Recommendations

| # | Recommendation | Expected Impact | Timeline |
|---|---------------|----------------|----------|
| 1 | Deploy 15–20% additional driver incentives Tue–Thu 5–6pm | +$15–20M annual revenue | Q1 |
| 2 | Launch dedicated JFK airport supply positioning programme | +$8–12M incremental revenue | Q2 |
| 3 | Run driver recruitment campaigns in February and September | Reduce peak cancellation rate by 8–12% | Ongoing |
| 4 | Create evening rush earnings calculator for driver onboarding | Improve driver 90-day retention by 10–15% | Q1 |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Google BigQuery | Cloud SQL on 30M+ rows |
| Python (pandas, seaborn, matplotlib) | EDA & visualisation |
| dbt Core | Data transformation & modeling |
| Tableau Public | Interactive live dashboard |
| Groq API + Llama 3.1 | AI-powered insight layer |
| GitHub | Version control |

---

## 🧹 Data Cleaning & Quality

| Issue | Threshold Applied | Rows Affected | Rationale |
|-------|-----------------|---------------|-----------|
| Fare outliers | $2.50–$500 | ~2% of rows | Min base fare $2.50; >$500 likely data entry errors |
| Distance outliers | 0.1–100 miles | ~1% of rows | Sub-0.1mi = cancelled/test trips; >100mi = GPS errors |
| Null timestamps | Removed | <0.5% of rows | Cannot assign to hour/day without pickup time |
| Pre-2022 records | Filtered to 2022 | ~0.1% of rows | Bad timestamp data (rows showing 2001–2009 dates) |
| Zero fares | Excluded | ~1% of rows | Likely driver test trips or data errors |

**Total rows retained:** ~96% of raw dataset (~29M of 30M trips)

---

## ⚠️ Limitations & Caveats

- **No cancellation data:** NYC TLC data excludes trips cancelled before pickup — actual demand is higher than trip counts suggest
- **Post-COVID baseline:** 2022 data reflects recovery-phase behaviour; pre-2020 patterns may differ significantly
- **No weather data:** Demand spikes/drops not cross-referenced with weather events — Jul 2022 drop may be partly weather-driven
- **Privacy constraints:** Individual rider IDs unavailable — retention analysis uses vendor-level proxies, not true cohort tracking
- **Zone approximation:** Location IDs mapped to zones using TLC lookup table — borough-level analysis is approximate
- **Platform mix:** Dataset includes yellow taxi + FHV (Uber/Lyft) — platform-specific patterns cannot be isolated

---

## 📊 Visualisations

| Chart | Insight |
|-------|---------|
| Demand Heatmap | Peak hours by day of week |
| Revenue by Segment | Which trip types drive most money |
| Tip Rate vs Volume | When riders are most generous |
| Monthly Trend | 2022 recovery story |
| MoM Growth | Demand acceleration patterns |
| Peak vs Off-Peak | Rush hour revenue dominance |

---

## 🔬 Analysis Methodology

- **Data source:** NYC TLC Trip Record Data via Google BigQuery public datasets
- **Dataset size:** 30M+ trips across January–November 2022
- **Tools:** BigQuery for cloud SQL, pandas for transformation, seaborn/matplotlib for visualisation, dbt for pipeline, Groq/Llama3 for AI insights
- **Approach:** Exploratory → Segmentation → Trend analysis → Business recommendations

---

## 📁 Project Structure

```text
urban-mobility-intelligence/
├── sql/                        # BigQuery analysis queries
│   ├── 01_demand_by_hour.sql
│   ├── 02_location_revenue.sql
│   └── 03_trip_segmentation.sql
├── notebooks/                  # Python EDA notebooks
│   ├── 01_demand_analysis.ipynb
│   └── 02_cohort_retention.ipynb
├── dashboard/                  # All visualisations
│   ├── demand_heatmap.png
│   ├── revenue_by_segment.png
│   ├── tip_rate_by_time.png
│   ├── monthly_trend.png
│   ├── mom_growth.png
│   ├── peak_vs_offpeak.png
│   └── dbt_lineage.png
├── mobility_dbt/               # dbt transformation pipeline
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_trips.sql
│   │   │   └── schema.yml
│   │   └── marts/
│   │       ├── fct_trips_daily.sql
│   │       └── fct_hourly_demand.sql
├── ai_insights/                # Groq + Llama3 AI insight engine
│   ├── insight_generator.py
│   └── sample_outputs/
│       └── latest_insights.json
├── docs/
│   └── findings_memo.md        # Business recommendations memo
├── data/                       # CSV exports from BigQuery
│   ├── demand_by_hour.csv
│   ├── location_revenue.csv
│   ├── trip_segmentation.csv
│   └── monthly_trips.csv
├── .gitignore
├── requirements.txt
└── README.md
```

---

## 📋 Read the Full Business Memo

👉 [Business Findings & Recommendations](docs/findings_memo.md)

---

## 🔭 What I'd Explore Next

The data raised more questions than it answered — which is usually the sign 
of a good analysis. Here's what I'd investigate with more time and resources:

**🌦️ Weather as a demand driver**  
The July 2022 -10.8% drop and the November dip are interesting anomalies. 
I'd cross-reference these with NYC weather data and public holidays to separate 
*structural* demand drops from *situational* ones. A ride-share PM can't act 
on "July is slow" — but they can act on "rainy Thursdays spike demand 23% 
in Midtown specifically."

**📍 Supply-demand gap by zone**  
The analysis shows WHERE demand is highest — but not WHERE drivers aren't 
showing up. The real revenue leak is the gap between demand and supply at 
the zone level. I'd build a driver supply vs trip request ratio by zone and 
hour to quantify exactly how much revenue is being left on the table due to 
cancellations.

**📊 Statistical validation of findings**  
Is the difference between evening rush (19% tip rate) and morning rush 
(18.1%) actually meaningful, or just noise in the data? I'd run t-tests 
across all time segment comparisons to confirm which findings are 
statistically significant before presenting them to a product team.

**📅 Multi-year seasonality validation**  
October's +15.3% surge and February's +21% recovery look like strong 
patterns — but 2022 was a post-COVID recovery year, which makes it an 
unusual baseline. I'd add 2021 and 2023 data to confirm whether these 
are repeatable seasonal patterns or one-time effects before building 
operational plans around them.

**👤 True rider cohort analysis**  
The NYC TLC dataset doesn't include individual rider IDs for privacy reasons, 
so my "cohort" analysis tracks aggregate monthly volume rather than true 
user retention. With access to anonymised rider IDs I'd build genuine 
D1/D7/D30 retention curves — the metric that actually predicts long-term 
platform health better than any volume number.

*Built with real NYC TLC public data. All insights are data-driven and reproducible.*