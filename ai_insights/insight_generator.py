import os
import json
import pandas as pd
from groq import Groq
from dotenv import load_dotenv

# Load API key from .env
load_dotenv()
client = Groq(api_key=os.getenv("GROQ_API_KEY"))

def load_data():
    """Load all CSV data from BigQuery exports"""
    demand = pd.read_csv('data/demand_by_hour.csv.csv')
    segments = pd.read_csv('data/trip_segmentation.csv.csv')
    monthly = pd.read_csv('data/monthly_trips.csv.csv')
    locations = pd.read_csv('data/location_revenue.csv.csv')

    # Filter monthly to 2022 only
    monthly['trip_month'] = pd.to_datetime(monthly['trip_month'])
    monthly = monthly[
        (monthly['trip_month'] >= '2022-01-01') &
        (monthly['trip_month'] <= '2022-11-30')
    ]
    return demand, segments, monthly, locations

def build_context(demand, segments, monthly, locations):
    """Build a COMPACT data summary to send to the AI"""

    # Top 3 demand hours only
    top_hours = demand.nlargest(3, 'total_trips')[
        ['hour_of_day','day_of_week','total_trips','avg_fare']
    ].to_string(index=False)

    # Segment revenue totals only
    seg_rev = segments.groupby('trip_segment')['total_revenue'].sum()
    seg_str = seg_rev.sort_values(ascending=False).to_string()

    # Monthly summary - just key stats
    monthly['month_label'] = monthly['trip_month'].dt.strftime('%b %Y')
    monthly['mom_growth'] = monthly['total_trips'].pct_change() * 100
    best_month = monthly.nlargest(1, 'total_trips')['month_label'].values[0]
    worst_mom = monthly['mom_growth'].min()
    best_mom = monthly['mom_growth'].max()
    total_trips = monthly['total_trips'].sum()
    total_rev = monthly['total_revenue'].sum()

    # Top 3 locations only
    top_locs = locations.nlargest(3, 'total_revenue')[
        ['pickup_location_id','total_trips','avg_fare','total_revenue']
    ].to_string(index=False)

    context = f"""
NYC Ride-Share 2022 Summary (30M+ trips):

TOP DEMAND HOURS:
{top_hours}

REVENUE BY TRIP TYPE:
{seg_str}

MONTHLY HIGHLIGHTS:
- Total trips: {total_trips:,.0f}
- Total revenue: ${total_rev/1e6:.1f}M
- Best month: {best_month}
- Best MoM growth: {best_mom:+.1f}%
- Worst MoM drop: {worst_mom:+.1f}%

TOP 3 PICKUP ZONES:
{top_locs}
"""
    return context

def generate_insight(question, context):
    """Send data + question to Groq AI and get insight back"""

    prompt = f"""You are a senior product analyst at a ride-share company like Uber or Lyft.
You have been given real NYC taxi trip data for 2022.
Answer the question below using ONLY the data provided.
Be specific, use numbers, and give a clear business recommendation.
Keep your answer to 3-5 sentences maximum.

DATA:
{context}

QUESTION: {question}

ANSWER:"""

    response = client.chat.completions.create(
        model="llama-3.1-8b-instant",
        messages=[{"role": "user", "content": prompt}],
        max_tokens=300,
        temperature=0.3
    )

    return response.choices[0].message.content

def generate_weekly_summary(context):
    """Generate an automated weekly ops summary"""

    prompt = f"""You are a senior data analyst at a ride-share company.
Based on the NYC 2022 trip data below, write a professional
Weekly Operations Summary memo.

Format it exactly like this:
WEEKLY OPS SUMMARY
==================
📈 DEMAND: [1 sentence about peak demand patterns]
💰 REVENUE: [1 sentence about revenue highlights]  
🚗 TRIP PATTERNS: [1 sentence about trip segment insights]
⚠️  WATCH OUT: [1 sentence about a risk or concerning trend]
✅ RECOMMENDATION: [1 actionable recommendation with a specific number]

DATA:
{context}"""

    response = client.chat.completions.create(
        model="llama-3.1-8b-instant",
        messages=[{"role": "user", "content": prompt}],
        max_tokens=400,
        temperature=0.4
    )

    return response.choices[0].message.content

def detect_anomalies(monthly):
    """Flag months with unusual growth patterns - aggregated level"""
    monthly_agg = monthly.groupby('trip_month').agg(
        total_trips=('total_trips','sum')
    ).reset_index().sort_values('trip_month')
    
    monthly_agg['mom_growth'] = monthly_agg['total_trips'].pct_change() * 100
    anomalies = monthly_agg[
        (monthly_agg['mom_growth'] > 15) |
        (monthly_agg['mom_growth'] < -8)
    ].copy()
    
    anomalies['trip_month'] = pd.to_datetime(
        anomalies['trip_month']).dt.strftime('%b %Y')
    anomalies['flag'] = anomalies['mom_growth'].apply(
        lambda x: '🚀 Surge' if x > 15 else '⚠️  Drop'
    )
    return anomalies

def main():
    print("🚕 Urban Mobility AI Insight Generator")
    print("=" * 50)
    print("Loading data...")

    demand, segments, monthly, locations = load_data()
    context = build_context(demand, segments, monthly, locations)
    print("✅ Data loaded")

    print("🤖 Generating AI insights (this takes ~30 seconds)...")

    # 1. Weekly summary
    summary = generate_weekly_summary(context)

    # 2. Anomaly detection
    anomalies = detect_anomalies(monthly)

    # 3. Q&A insights
    questions = [
        "Which time of day should we prioritise driver supply to maximise revenue?",
        "What is the biggest revenue opportunity we are currently missing?",
        "Which months should we run driver recruitment campaigns and why?"
    ]

    insights = []
    for q in questions:
        answer = generate_insight(q, context)
        insights.append({'question': q, 'answer': answer})

    # Save everything to file
    output = {
        'generated_at': pd.Timestamp.now().strftime('%Y-%m-%d %H:%M:%S'),
        'weekly_summary': summary,
        'anomalies': anomalies[['trip_month','mom_growth','flag']].to_dict('records'),
        'insights': insights
    }

    os.makedirs('ai_insights/sample_outputs', exist_ok=True)
    with open('ai_insights/sample_outputs/latest_insights.json', 'w') as f:
        json.dump(output, f, indent=2)

    print("✅ All insights saved to ai_insights/sample_outputs/latest_insights.json")
    print("🎉 Done!")

if __name__ == "__main__":
    main()