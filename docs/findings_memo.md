# Urban Mobility Intelligence — Business Findings Memo

**Prepared by:** Rakshitha Ravi  
**Dataset:** NYC TLC Trip Records 2022 (30M+ trips)  
**Date:** May 2026  
**Audience:** Product & Operations Leadership  

---

## Executive Summary

Analysis of 30 million NYC ride-share trips in 2022 reveals four high-impact 
opportunities to grow revenue and improve driver retention. Peak hours drive 
72% of all revenue despite covering less than 20% of daily hours. Strategic 
driver supply allocation during these windows represents the single highest-ROI 
lever available to the operations team.

---

## Key Findings

### 1. Peak hours are massively underserved relative to their revenue contribution

Tuesday through Thursday between 5pm and 6pm consistently generates 370,000+ 
trips per hour — the highest demand window of the week. This single hour slot 
accounts for a disproportionate share of weekly revenue.

**Implication:** A 10% increase in driver availability during peak windows 
could unlock an estimated $15–20M in incremental annual revenue by reducing 
trip cancellations due to wait time.

---

### 2. Short trips dominate volume but the real margin is in long-haul

Trips under 5 miles represent 60% of all trips but average only $7–14 per 
fare. Airport and long-haul trips (20+ miles) average $46+ per trip — 
6x higher revenue per ride.

JFK Airport (Zone 132) alone generated **$102 million** in revenue from 
1.66 million trips in 2022. This single pickup zone outperforms entire 
boroughs combined.

**Implication:** A dedicated airport supply strategy — incentivising drivers 
to position near JFK during peak flight arrival windows — could meaningfully 
increase high-margin trip share without acquiring new riders.

---

### 3. NYC ride-share demand follows a predictable seasonal pattern

| Month | MoM Growth | Driver |
|-------|-----------|--------|
| Feb 2022 | +21% | Post-COVID demand recovery |
| Mar 2022 | +21.6% | Spring return to offices |
| Jul 2022 | -10.8% | Summer exodus from NYC |
| Oct 2022 | +15.3% | Fall return-to-office surge |
| Nov 2022 | -11.7% | Thanksgiving travel disruption |

**Implication:** Driver recruitment campaigns should be timed to February and 
September — one month before the two major demand surges. Running recruitment 
in October (after the surge has already started) leaves revenue on the table.

---

### 4. Evening rush riders are the highest-value rider segment

Evening rush (5–7pm) has the highest tip rate at **19%** — outperforming 
late night (18.9%), morning rush (18.1%), and off-peak (18.1%). These riders 
are also high frequency — commuters who ride multiple times per week.

**Implication:** Driver satisfaction programs should highlight evening rush 
earning potential. Drivers who understand that 5–7pm shifts combine high 
volume AND high tips are more likely to stay active during this critical window.

---

## Business Recommendations

| # | Recommendation | Expected Impact | Timeline |
|---|---------------|----------------|----------|
| 1 | Deploy 15–20% additional driver incentives Tue–Thu 5–6pm | +$15–20M annual revenue | Q1 |
| 2 | Launch dedicated JFK airport supply positioning programme | +$8–12M incremental revenue | Q2 |
| 3 | Run driver recruitment campaigns in February and September | Reduce peak cancellation rate by 8–12% | Ongoing |
| 4 | Create evening rush earnings calculator for driver onboarding | Improve driver 90-day retention by 10–15% | Q1 |

---

## Methodology

- **Data source:** NYC TLC Trip Record Data via Google BigQuery public datasets
- **Dataset size:** 30M+ trips across January–November 2022
- **Data cleaning:** Filtered fare outliers ($2.50–$500), distance outliers 
  (0.1–100 miles), removed null timestamps and pre-2022 records
- **Tools:** BigQuery (SQL), Python (pandas, matplotlib, seaborn), 
  dbt (transformation pipeline), Tableau (visualisation), Groq/Llama3 (AI insights)
- **Limitations:** Dataset uses location IDs not borough names — zone mapping 
  approximated from TLC zone lookup table. Individual rider IDs not available 
  due to privacy — retention analysis uses trip frequency proxies.

---

## Appendix — Supporting Visualisations

| Chart | Key Takeaway |
|-------|-------------|
| Demand Heatmap | Thu-Fri 5-6pm = peak demand across all weeks |
| Monthly Trend | Feb-Mar surge and Oct return-to-office clearly visible |
| Revenue by Segment | Very short trips dominate volume, long-haul dominates margin |
| Tip Rate by Time | Evening rush = highest rider satisfaction signal |
| Peak vs Off-Peak | Rush hours = 72% of $759M annual revenue |

📊 **Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/rakshitha.ravishankar/viz/urbanmobility_17801925970410/UrbanMobilityIntelligenceNYCRide-ShareAnalytics)

💻 **GitHub Repository:** [urban-mobility-intelligence](https://github.com/RAKSHITHA-RAVI/urban-mobility-intelligence)

---

*This analysis was conducted independently using publicly available NYC TLC 
data. All revenue figures are derived from the public dataset and represent 
the analysed sample, not official company financials.*