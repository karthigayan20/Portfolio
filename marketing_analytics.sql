/* =============================================================================
   Project 2 — Marketing performance metric layer
   Author : RP Karthigayan
   Source : marketing_channel_performance.csv  (72 rows: 6 channels x 12 months)
   Dialect: PostgreSQL (ANSI-compatible; runs on BigQuery/Snowflake with minor
            date-function changes noted inline)

   NOTE ON THE DATA: this dataset is simulated so the analysis can be published
   openly. The metric definitions below are the ones I use on real client data.

   METRIC DEFINITIONS (agreed once, reused everywhere - this is the whole point
   of a metric layer; if CAC is defined in five dashboards it has five values):
     CTR              = clicks / impressions
     CPC              = spend / clicks                 [media channels only]
     CPL              = spend / leads
     CAC              = spend / new_customers
     Lead-to-customer = new_customers / leads
     ROAS             = first_year_revenue / spend
     Payback (months) = CAC / (avg_mrr * gross_margin)
   ============================================================================= */

-- Table used by every query below.
-- CREATE TABLE channel_performance (
--   month                  date        NOT NULL,   -- first day of month
--   channel                text        NOT NULL,
--   spend_usd              numeric(12,2) NOT NULL,
--   impressions            bigint      NOT NULL,
--   clicks                 bigint      NOT NULL,
--   leads                  integer     NOT NULL,
--   qualified_leads        integer     NOT NULL,
--   new_customers          integer     NOT NULL,
--   new_mrr_usd            numeric(12,2) NOT NULL,
--   first_year_revenue_usd numeric(12,2) NOT NULL,
--   PRIMARY KEY (month, channel)
-- );


/* -----------------------------------------------------------------------------
   1. Business assumptions in one place, referenced by name.
   Hardcoding 0.72 in six queries is how two dashboards start disagreeing.
   -------------------------------------------------------------------------- */
WITH assumptions AS (
    SELECT 149.00::numeric AS avg_mrr,          -- average plan price
           0.72::numeric   AS gross_margin,     -- used for payback only
           250.00::numeric AS target_cac,       -- planning threshold
           5.00::numeric   AS target_roas
),

/* -----------------------------------------------------------------------------
   2. Channel-level scorecard, full period. This is the query that drives the
      channel table on the dashboard.
   -------------------------------------------------------------------------- */
channel_totals AS (
    SELECT cp.channel,
           SUM(cp.spend_usd)              AS spend,
           SUM(cp.impressions)            AS impressions,
           SUM(cp.clicks)                 AS clicks,
           SUM(cp.leads)                  AS leads,
           SUM(cp.qualified_leads)        AS qualified_leads,
           SUM(cp.new_customers)          AS customers,
           SUM(cp.new_mrr_usd)            AS new_mrr,
           SUM(cp.first_year_revenue_usd) AS revenue
    FROM   channel_performance cp
    GROUP  BY cp.channel
)
SELECT ct.channel,
       ct.spend,
       ct.customers,
       ROUND(100.0 * ct.clicks    / NULLIF(ct.impressions, 0), 2) AS ctr_pct,
       -- media channels only: for organic/email/partner, "spend" is production
       -- and commission cost, so a cost-per-click would be meaningless.
       CASE WHEN ct.channel IN ('Google Search Ads','Meta Ads','LinkedIn Ads')
            THEN ROUND(ct.spend / NULLIF(ct.clicks, 0), 2) END      AS cpc,
       ROUND(ct.spend / NULLIF(ct.leads, 0), 2)                     AS cpl,
       ROUND(ct.spend / NULLIF(ct.customers, 0), 2)                 AS cac,
       ROUND(100.0 * ct.customers / NULLIF(ct.leads, 0), 2)         AS lead_to_customer_pct,
       ROUND(ct.revenue / NULLIF(ct.spend, 0), 2)                   AS roas,
       ROUND((ct.spend / NULLIF(ct.customers, 0))
             / (a.avg_mrr * a.gross_margin), 1)                     AS payback_months,
       -- the two shares that sit side by side on the dashboard: where they
       -- diverge, budget is in the wrong channel.
       ROUND(100.0 * ct.spend     / SUM(ct.spend)     OVER (), 1)   AS share_of_spend_pct,
       ROUND(100.0 * ct.customers / SUM(ct.customers) OVER (), 1)   AS share_of_customers_pct,
       CASE WHEN ct.spend / NULLIF(ct.customers, 0) > a.target_cac * 2 THEN 'cut'
            WHEN ct.spend / NULLIF(ct.customers, 0) > a.target_cac     THEN 'hold'
            ELSE 'fund' END                                         AS budget_action
FROM   channel_totals ct
CROSS  JOIN assumptions a
ORDER  BY cac;


/* -----------------------------------------------------------------------------
   3. Monthly blended trend with month-over-month movement.
      Drives the spend-vs-CAC combo chart and the ROAS-vs-floor chart.
   -------------------------------------------------------------------------- */
WITH monthly AS (
    SELECT month,
           SUM(spend_usd)              AS spend,
           SUM(leads)                  AS leads,
           SUM(new_customers)          AS customers,
           SUM(first_year_revenue_usd) AS revenue
    FROM   channel_performance
    GROUP  BY month
)
SELECT month,
       spend,
       customers,
       ROUND(spend / NULLIF(customers, 0), 2)                        AS blended_cac,
       ROUND(revenue / NULLIF(spend, 0), 2)                          AS blended_roas,
       ROUND(spend / NULLIF(leads, 0), 2)                            AS cpl,
       ROUND(100.0 * (spend / NULLIF(customers, 0))
             / NULLIF(LAG(spend / NULLIF(customers, 0))
                      OVER (ORDER BY month), 0) - 100, 1)            AS cac_mom_pct,
       ROUND(AVG(spend / NULLIF(customers, 0))
             OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
                                                                     AS cac_3mo_rolling
FROM   monthly
ORDER  BY month;


/* -----------------------------------------------------------------------------
   4. Seasonality check: which months are structurally expensive?
      Answers "should the budget be flat month to month?" (it should not).
   -------------------------------------------------------------------------- */
WITH monthly AS (
    SELECT month,
           SUM(spend_usd) AS spend,
           SUM(new_customers) AS customers
    FROM   channel_performance
    GROUP  BY month
),
scored AS (
    SELECT month,
           spend,
           customers,
           spend / NULLIF(customers, 0)                     AS cac,
           AVG(spend / NULLIF(customers, 0)) OVER ()        AS avg_cac
    FROM   monthly
)
SELECT month,
       ROUND(cac, 2)                                        AS cac,
       ROUND(100.0 * (cac / avg_cac - 1), 1)                AS vs_average_pct,
       CASE WHEN cac > avg_cac * 1.08 THEN 'expensive - flex budget down'
            WHEN cac < avg_cac * 0.95 THEN 'efficient - lean in'
            ELSE 'in line' END                              AS read
FROM   scored
ORDER  BY cac DESC;


/* -----------------------------------------------------------------------------
   5. Channel x month CAC matrix, for spotting a channel that degraded rather
      than a whole market that got expensive.
   -------------------------------------------------------------------------- */
SELECT channel,
       month,
       SUM(spend_usd)                                           AS spend,
       SUM(new_customers)                                       AS customers,
       ROUND(SUM(spend_usd) / NULLIF(SUM(new_customers), 0), 2) AS cac,
       -- each channel compared against its own 12-month average, not the blend
       ROUND(100.0 * (SUM(spend_usd) / NULLIF(SUM(new_customers), 0))
             / AVG(SUM(spend_usd) / NULLIF(SUM(new_customers), 0))
                 OVER (PARTITION BY channel) - 100, 1)          AS vs_own_avg_pct
FROM   channel_performance
GROUP  BY channel, month
ORDER  BY channel, month;


/* -----------------------------------------------------------------------------
   6. Acquisition cascade: impressions -> clicks -> leads -> qualified -> customers.
      Presented as one row per stage so it can be charted directly.
   -------------------------------------------------------------------------- */
WITH totals AS (
    SELECT SUM(impressions)     AS impressions,
           SUM(clicks)          AS clicks,
           SUM(leads)           AS leads,
           SUM(qualified_leads) AS qualified_leads,
           SUM(new_customers)   AS customers
    FROM   channel_performance
),
stages AS (
    SELECT 1 AS stage_order, 'Impressions'     AS stage, impressions     AS volume, NULL::bigint AS prev FROM totals
    UNION ALL SELECT 2, 'Clicks',          clicks,          impressions     FROM totals
    UNION ALL SELECT 3, 'Leads',           leads,           clicks          FROM totals
    UNION ALL SELECT 4, 'Qualified leads', qualified_leads, leads           FROM totals
    UNION ALL SELECT 5, 'New customers',   customers,       qualified_leads FROM totals
)
SELECT stage,
       volume,
       ROUND(100.0 * volume / NULLIF(prev, 0), 3) AS conversion_from_prev_pct,
       prev - volume                              AS lost_at_stage
FROM   stages
ORDER  BY stage_order;


/* -----------------------------------------------------------------------------
   7. Reallocation model in SQL: what does flat spend buy if 60% of the worst
      channel's budget moves to the three cheapest?

      Incremental CAC is deliberately set worse than current CAC (diminishing
      returns), and each receiving channel is capped by a growth ceiling. A model
      that assumes cheap customers scale forever is the most common way a
      reallocation deck overpromises.
   -------------------------------------------------------------------------- */
WITH ct AS (
    SELECT channel,
           SUM(spend_usd)     AS spend,
           SUM(new_customers) AS customers,
           SUM(spend_usd) / NULLIF(SUM(new_customers), 0) AS cac
    FROM   channel_performance
    GROUP  BY channel
),
plan (channel, budget_share, inc_cac_multiple, growth_ceiling) AS (
    VALUES ('Partner / Agency',  0.60, 2.5, 0.35),   -- scales with investment
           ('Email / Lifecycle', 0.15, 3.6, 0.15),   -- capacity-bound, not budget-bound
           ('SEO / Organic',     0.25, 3.0, 0.20)    -- two-quarter lag
),
source AS (   -- budget released from the worst-CAC channel
    SELECT channel, spend, cac, spend * 0.60 AS released
    FROM   ct
    WHERE  cac = (SELECT MAX(cac) FROM ct)
),
receiving AS (
    SELECT p.channel,
           s.released * p.budget_share              AS budget_added,
           ct.cac * p.inc_cac_multiple              AS incremental_cac,
           (s.released * p.budget_share) / (ct.cac * p.inc_cac_multiple) AS uncapped_customers,
           ct.customers * p.growth_ceiling          AS ceiling_customers
    FROM   plan p
    JOIN   ct ON ct.channel = p.channel
    CROSS  JOIN source s
)
SELECT r.channel,
       ROUND(r.budget_added, 2)                                   AS budget_added,
       ROUND(r.incremental_cac, 2)                                AS incremental_cac,
       ROUND(r.uncapped_customers, 1)                             AS uncapped_customers,
       ROUND(r.ceiling_customers, 1)                              AS growth_ceiling,
       ROUND(LEAST(r.uncapped_customers, r.ceiling_customers), 1) AS modelled_customers,
       r.uncapped_customers > r.ceiling_customers                 AS ceiling_applied
FROM   receiving r
UNION ALL
SELECT 'NET EFFECT (customers gained - lost)',
       0, NULL, NULL, NULL,
       ROUND((SELECT SUM(LEAST(uncapped_customers, ceiling_customers)) FROM receiving)
             - (SELECT released / cac FROM source), 1),
       NULL;


/* -----------------------------------------------------------------------------
   8. Weekly monitoring query. The analysis above is a one-off; this is the
      thing that keeps it true. Any channel breaching the payback threshold
      surfaces on its own instead of waiting for the next quarterly review.
   -------------------------------------------------------------------------- */
WITH recent AS (
    SELECT channel,
           SUM(spend_usd)     AS spend,
           SUM(new_customers) AS customers
    FROM   channel_performance
    -- BigQuery: DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)
    WHERE  month >= (SELECT MAX(month) FROM channel_performance) - INTERVAL '3 months'
    GROUP  BY channel
)
SELECT channel,
       ROUND(spend / NULLIF(customers, 0), 2)                                AS cac_last_3mo,
       ROUND((spend / NULLIF(customers, 0)) / (149.00 * 0.72), 1)            AS payback_months,
       CASE WHEN (spend / NULLIF(customers, 0)) / (149.00 * 0.72) > 6
            THEN 'BREACH - review budget this week'
            WHEN (spend / NULLIF(customers, 0)) / (149.00 * 0.72) > 3
            THEN 'watch'
            ELSE 'healthy' END                                              AS status
FROM   recent
ORDER  BY cac_last_3mo DESC;
