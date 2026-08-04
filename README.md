# RP Karthigayan — Marketing Operations & Growth Analytics Portfolio

Three end-to-end case studies in marketing analytics, product funnel analysis and go-to-market
strategy. Each one carries a business problem, a dataset, SQL, a dashboard, and a recommendation with
money attached to it.

**Open `index.html` to start.**

Every project page runs the full flow top to bottom — business problem, dataset, method, dashboard,
insights, recommendations and impact — with a jump nav at the top, a **Materials & assets** section
at the bottom linking every file that produced it, and next/previous links to the other two projects.

📧 karthickoffical2009@gmail.com · 📱 +91 7448958006 · 📍 Chennai, India

---

## Read this first: the data is simulated

Every dataset in this repository is **generated, not client data**. I work on US client accounts under
confidentiality, so publishing real numbers is not an option. Rather than describe work nobody can
inspect, I built realistic datasets and ran the full analysis on them in the open.

What that means:

- **The numbers are real computations,** not illustrations. Every figure on every page is calculated
  from the published CSVs — you can rerun the SQL and get the same answers.
- **The method is what I use on real data.** Metric definitions, funnel logic, segment tests and
  opportunity sizing are unchanged.
- **The results are not claims about a real company.** LumaLocal is fictional.
- **Employer results in my résumé are separate** and come from real work.

Every page states this. I would rather be checkable than impressive.

---

## The three projects

### P1 · GTM Strategy & 90-Day Launch
Launching an AI module into a partner-led (agency reseller) channel: positioning, ranked ICP,
competitive archetypes, pricing built around partner margin, message map, enablement, and a 13-week
scorecard measured against targets fixed before launch.

| Metric | Target | Actual |
|---|---|---|
| Attach rate (weeks 10–13) | 55.0% | **61.7%** ✅ |
| Partner reps enabled | 275 | **284** ✅ |
| Demos booked | 900 | **770** ❌ |
| Closed-won | 185 | **169** ⚠️ |
| Module MRR | $9,500 | **$8,562** ⚠️ |

**The interesting part is the miss.** Attach rate and enablement beat plan while demos came in 14%
short — the constraint was demand generation, not the product story. The retrospective names the
measurement failure: every target was a supply-side metric, so the scorecard could look healthy while
pipeline was flat.

📄 `project-1-gtm-launch.html` · `gtm-document.html` · `launch_scorecard_90day.csv`

---

### P2 · Marketing Performance Dashboard
Twelve months, six channels, $709k of spend reduced to the numbers a marketing lead decides on: CTR,
CPC, CPL, CAC, ROAS, payback, and share of spend versus share of customers.

**Findings**
- LinkedIn Ads costs **$928** per customer — 4.0× blended — with an 8.6-month payback, taking 17.1%
  of spend for 4.3% of customers
- Partner/agency referral delivers **30.6% of customers on 11.6% of spend** at $87 CAC
- Blended CAC swings **35%** between the cheapest and most expensive month on flat spend

**Recommendation:** reallocate 60% of the LinkedIn budget to partner acquisition, lifecycle email and
SEO at **flat total spend** → **+230 customers (+7.5%)**, blended CAC **$230 → $214**, ~**$361k**
added first-year revenue. Incremental CAC is set 2.5–3.6× worse than current CAC and each receiving
channel is capped by a growth ceiling, because cheap customers do not scale forever.

LinkedIn is reduced, not switched off: in P3 its signups convert to paid at the second-highest rate of
any channel, so it is buying fewer but better accounts.

📊 `project-2-marketing-analytics.html` · `marketing_analytics.sql` ·
`Marketing_Analytics_Workbook.xlsx` · `marketing_channel_performance.csv`

---

### P3 · Customer Funnel Analysis
14,200 signups across eight funnel steps, cut by acquisition channel, device, account segment and
onboarding path, with cohort stability checks and conservative opportunity sizing.

**Findings**
- One step — connecting a business listing — loses **49.5%** of the users who reach it: **5,208 users**
  in six months
- Mobile completes that step at **37.1%** versus **58.2%** on desktop: a 21-point gap on an OAuth flow
  never designed for a small screen
- Activated accounts convert to paid at **20.3%**; accounts that never activate convert at **1.5%**
- Guided setup: **47.8%** activation vs **24.1%** self-serve — but it covers only 22% of signups
- The rate is flat across all six cohorts, which rules out an incident and points to a persistent
  design problem

**Sizing:** recovering just **10 points** of that step is worth **+168 paying accounts**, ~**$25k
MRR**, ~**$300k annualised** — using the activated-only paid conversion rate, which excludes
sales-assisted deals that would have flattered the number.

📊 `project-3-funnel-analysis.html` · `funnel_analysis.sql` · `product_funnel_users.csv`

---

## Repository contents

| File | What it is |
|---|---|
| `index.html` | Portfolio homepage — start here |
| `project-1-gtm-launch.html` | GTM launch brief + 90-day scorecard |
| `project-2-marketing-analytics.html` | Channel performance dashboard |
| `project-3-funnel-analysis.html` | Funnel and leakage dashboard |
| `gtm-document.html` | The GTM document rendered as a web page — open this one |
| `GTM-Strategy-Reputation-AI.md` | Markdown source of the GTM document |
| `marketing_analytics.sql` | 8 queries: metric layer, seasonality, cascade, reallocation, monitoring |
| `funnel_analysis.sql` | 8 queries: funnel, segment cuts, cohorts, sizing, monitoring view |
| `Marketing_Analytics_Workbook.xlsx` | Excel model, 269 live formulas, all levers on one Assumptions sheet |
| `marketing_channel_performance.csv` | 72 rows — 6 channels × 12 months |
| `product_funnel_users.csv` | 14,200 user rows, 8 funnel flags, 4 segment dimensions |
| `launch_scorecard_90day.csv` | 13 weeks of launch metrics |

**To add:** drop your résumé into this folder as `Karthigayan_Resume.pdf` — the portfolio links to
that filename.

## Running it

The dashboards are self-contained HTML — no build step, no dependencies, no tracking. Open any file
in a browser. Charts are hand-written SVG and CSS, so they work offline (web fonts need a connection;
there are fallbacks if there isn't one).

For GitHub Pages: push to a repo, enable Pages on the root of `main`, and `index.html` becomes the
live site.

## Stack

SQL (PostgreSQL) · Python (pandas, numpy, openpyxl) · Advanced Excel · Power BI (metric logic
transfers directly) · HTML/CSS/JavaScript · Google Analytics 4 · n8n

## How each project is documented

Every project page follows the same ten-point structure, because a dashboard without a stated decision
is a report nobody opens twice:

1. Business problem · 2. Objective · 3. Dataset · 4. Tools · 5. Approach · 6. Dashboard ·
7. Key insights · 8. Recommendations · 9. Business impact, quantified · 10. Method and limits

Point 10 is the one usually left out. Each project states what the analysis cannot prove —
correlational segment findings, last-touch attribution, censored cohorts — because that is what a
hiring manager will probe in an interview anyway.

---

*Open to marketing operations, growth analytics, revenue operations, product marketing and GTM roles.
Happy to walk through the SQL or the assumptions in detail.*
