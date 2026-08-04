/* =============================================================================
   Project 3 — Customer funnel & leakage analysis
   Author : RP Karthigayan
   Source : product_funnel_users.csv  (14,200 user rows, 6 monthly cohorts)
   Dialect: PostgreSQL

   NOTE ON THE DATA: simulated so it can be published openly. The funnel logic,
   segment tests and sizing method are the ones I use on real product data.

   FUNNEL DEFINITION (agreed with product before any query was written):
     1 signed_up               account created
     2 email_verified          email confirmed
     3 profile_completed       business details entered
     4 listing_connected       Google Business Profile / listing OAuth completed
     5 first_report_published  ACTIVATION - the account has produced value once
     6 converted_to_paid       trial -> paid
     7 retained_day_30
     8 retained_day_90

   teammate_invited is NOT a funnel step. It can happen at any point, so making
   it a gate would inflate every conversion rate below it. It is analysed
   separately as a retention correlate in query 6.
   ============================================================================= */

-- CREATE TABLE funnel_users (
--   user_id                text PRIMARY KEY,
--   signup_month           date    NOT NULL,
--   acquisition_channel    text    NOT NULL,
--   onboarding_path        text    NOT NULL,   -- 'Self-serve' | 'Guided setup'
--   device                 text    NOT NULL,   -- 'Desktop' | 'Mobile'
--   account_segment        text    NOT NULL,   -- 'Single location' | 'Multi-location' | 'Agency'
--   signed_up              smallint NOT NULL,
--   email_verified         smallint NOT NULL,
--   profile_completed      smallint NOT NULL,
--   listing_connected      smallint NOT NULL,
--   first_report_published smallint NOT NULL,
--   converted_to_paid      smallint NOT NULL,
--   retained_day_30        smallint NOT NULL,
--   retained_day_90        smallint NOT NULL,
--   teammate_invited       smallint NOT NULL,
--   days_to_activation     numeric,
--   mrr_usd                numeric(10,2) NOT NULL DEFAULT 0
-- );


/* -----------------------------------------------------------------------------
   1. The funnel. One row per step, with three different denominators, because
      "conversion rate" means three different things to three different people:
        - pct_of_signup : how much of the top of funnel survives (exec view)
        - step_conv     : how well THIS step performs (product view)
        - drop_pct      : where to spend engineering time (my view)
   -------------------------------------------------------------------------- */
WITH steps AS (
    SELECT 1 AS step_order, 'Signed up'                  AS step_label, SUM(signed_up)              AS users FROM funnel_users
    UNION ALL SELECT 2, 'Email verified',                SUM(email_verified)         FROM funnel_users
    UNION ALL SELECT 3, 'Business profile completed',    SUM(profile_completed)      FROM funnel_users
    UNION ALL SELECT 4, 'Listing/integration connected', SUM(listing_connected)      FROM funnel_users
    UNION ALL SELECT 5, 'First report published',        SUM(first_report_published) FROM funnel_users
    UNION ALL SELECT 6, 'Converted to paid',             SUM(converted_to_paid)      FROM funnel_users
    UNION ALL SELECT 7, 'Retained day 30',               SUM(retained_day_30)        FROM funnel_users
    UNION ALL SELECT 8, 'Retained day 90',               SUM(retained_day_90)        FROM funnel_users
),
sequenced AS (
    SELECT step_order,
           step_label,
           users,
           FIRST_VALUE(users) OVER (ORDER BY step_order)         AS top_of_funnel,
           LAG(users)         OVER (ORDER BY step_order)         AS prev_users
    FROM   steps
)
SELECT step_order,
       step_label,
       users,
       ROUND(100.0 * users / top_of_funnel, 2)                    AS pct_of_signup,
       ROUND(100.0 * users / NULLIF(prev_users, 0), 2)            AS step_conversion_pct,
       COALESCE(prev_users - users, 0)                            AS users_lost,
       ROUND(100.0 * (prev_users - users) / NULLIF(prev_users, 0), 2) AS drop_pct,
       -- flags the single worst step without anyone having to eyeball the table
       CASE WHEN (prev_users - users) = MAX(prev_users - users) OVER ()
            THEN 'LARGEST LEAK' END                               AS flag
FROM   sequenced
ORDER  BY step_order;


/* -----------------------------------------------------------------------------
   2. Segment cuts on the leaking step. Written once and re-run per dimension
      via UNION ALL so every cut lands in one result set with the same columns -
      much easier to chart, and impossible for the numbers to disagree.
   -------------------------------------------------------------------------- */
WITH cuts AS (
    SELECT 'Device'          AS dimension, device          AS segment, * FROM funnel_users
    UNION ALL SELECT 'Onboarding path', onboarding_path,    * FROM funnel_users
    UNION ALL SELECT 'Channel',         acquisition_channel,* FROM funnel_users
    UNION ALL SELECT 'Account segment', account_segment,    * FROM funnel_users
)
SELECT dimension,
       segment,
       COUNT(*)                                                            AS signups,
       -- the leaking step, measured against the step that precedes it
       ROUND(100.0 * SUM(listing_connected)
             / NULLIF(SUM(profile_completed), 0), 2)                       AS listing_step_conv_pct,
       ROUND(100.0 * SUM(first_report_published) / COUNT(*), 2)            AS activation_pct,
       ROUND(100.0 * SUM(converted_to_paid) / COUNT(*), 2)                 AS paid_pct,
       ROUND(100.0 * SUM(retained_day_90)
             / NULLIF(SUM(converted_to_paid), 0), 2)                       AS d90_retention_of_paid_pct,
       ROUND(AVG(days_to_activation)::numeric, 1)                          AS avg_days_to_activation,
       SUM(mrr_usd)                                                        AS mrr
FROM   cuts
GROUP  BY dimension, segment
ORDER  BY dimension,
          listing_step_conv_pct DESC;


/* -----------------------------------------------------------------------------
   3. Cohort stability check. If the leak is a persistent design problem the
      rate is flat across cohorts; if it were an incident, one month would spike.
      This is what stops a team from waiting for the problem to fix itself.
   -------------------------------------------------------------------------- */
SELECT signup_month,
       COUNT(*)                                                        AS signups,
       ROUND(100.0 * SUM(email_verified)         / COUNT(*), 1)        AS verified_pct,
       ROUND(100.0 * SUM(listing_connected)      / COUNT(*), 1)        AS listing_connected_pct,
       ROUND(100.0 * SUM(first_report_published) / COUNT(*), 1)        AS activation_pct,
       ROUND(100.0 * SUM(converted_to_paid)      / COUNT(*), 2)        AS paid_pct,
       ROUND(100.0 * SUM(retained_day_90)        / COUNT(*), 2)        AS retained_d90_pct,
       -- variance of the leaking step against the all-cohort average
       ROUND(100.0 * SUM(listing_connected) / COUNT(*)
             - AVG(100.0 * SUM(listing_connected) / COUNT(*)) OVER (), 1) AS listing_vs_avg_pts
FROM   funnel_users
GROUP  BY signup_month
ORDER  BY signup_month;


/* -----------------------------------------------------------------------------
   4. Activation as the hinge: does activating actually cause paid conversion,
      or is it just correlated with intent? This query cannot prove causation,
      but a 13x gap is large enough to justify an experiment.
   -------------------------------------------------------------------------- */
SELECT CASE WHEN first_report_published = 1 THEN 'Activated'
            ELSE 'Never activated' END                              AS cohort,
       COUNT(*)                                                     AS accounts,
       SUM(converted_to_paid)                                       AS paid,
       ROUND(100.0 * SUM(converted_to_paid) / COUNT(*), 2)          AS paid_conversion_pct,
       ROUND(100.0 * SUM(retained_day_90)
             / NULLIF(SUM(converted_to_paid), 0), 2)                AS d90_retention_of_paid_pct,
       ROUND(SUM(mrr_usd), 2)                                       AS mrr,
       ROUND(AVG(mrr_usd) FILTER (WHERE converted_to_paid = 1), 2)  AS arpa
FROM   funnel_users
GROUP  BY 1;


/* -----------------------------------------------------------------------------
   5. Time to first value, split by onboarding path. Median, not mean - a few
      accounts that activate on day 40 would otherwise move the average and
      hide the typical experience.
   -------------------------------------------------------------------------- */
SELECT onboarding_path,
       COUNT(*) FILTER (WHERE first_report_published = 1)                       AS activated,
       ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_activation)::numeric, 1) AS median_days,
       ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY days_to_activation)::numeric, 1) AS p90_days,
       ROUND(100.0 * SUM(converted_to_paid) / COUNT(*), 2)                      AS paid_pct
FROM   funnel_users
WHERE  first_report_published = 1
GROUP  BY onboarding_path
ORDER  BY median_days;


/* -----------------------------------------------------------------------------
   6. Teammate invitation as a retention correlate, measured on paying accounts
      only so acquisition quality is not mistaken for a retention effect.
   -------------------------------------------------------------------------- */
SELECT CASE WHEN teammate_invited = 1 THEN 'Invited a teammate'
            ELSE 'Solo account' END                             AS cohort,
       COUNT(*)                                                 AS paying_accounts,
       ROUND(100.0 * SUM(retained_day_30) / COUNT(*), 2)        AS d30_pct,
       ROUND(100.0 * SUM(retained_day_90) / COUNT(*), 2)        AS d90_pct,
       ROUND(AVG(mrr_usd), 2)                                   AS arpa
FROM   funnel_users
WHERE  converted_to_paid = 1
GROUP  BY 1;


/* -----------------------------------------------------------------------------
   7. Opportunity sizing. Deliberately conservative:
        - recovers 10 points of the failing step, not the whole gap
        - uses the activated-only paid conversion rate, which excludes
          sales-assisted deals that skip activation and would flatter the number
        - states the assumption in the output rather than in a footnote nobody
          reads
   -------------------------------------------------------------------------- */
WITH base AS (
    SELECT SUM(profile_completed)      AS entered_step,
           SUM(listing_connected)      AS passed_step,
           SUM(first_report_published) AS activated
    FROM   funnel_users
),
rates AS (
    SELECT b.entered_step,
           b.passed_step,
           b.entered_step - b.passed_step                            AS lost_at_step,
           b.activated::numeric / NULLIF(b.passed_step, 0)           AS listing_to_activation,
           (SELECT AVG(converted_to_paid::numeric)
            FROM   funnel_users
            WHERE  first_report_published = 1)                       AS activated_to_paid,
           149.00::numeric                                           AS avg_mrr
    FROM   base b
),
sized AS (
    SELECT entered_step,
           lost_at_step,
           entered_step * 0.10                                          AS users_recovered,
           entered_step * 0.10 * listing_to_activation                  AS extra_activations,
           entered_step * 0.10 * listing_to_activation * activated_to_paid AS extra_paid,
           avg_mrr
    FROM   rates
)
SELECT lost_at_step                                          AS users_currently_lost,
       ROUND(users_recovered, 0)                             AS users_recovered_at_10pts,
       ROUND(extra_activations, 0)                            AS extra_activations,
       ROUND(extra_paid, 0)                                   AS extra_paying_accounts,
       ROUND(extra_paid * avg_mrr, 0)                         AS extra_mrr,
       ROUND(extra_paid * avg_mrr * 12, 0)                    AS extra_annualised_revenue,
       '10-point recovery over 6 cohorts; activated-only paid rate; volume held flat'
                                                             AS assumptions
FROM   sized;


/* -----------------------------------------------------------------------------
   8. Monitoring view: weekly listing-connection rate by device, so the fix can
      be verified rather than assumed once engineering ships it.
   -------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW v_listing_step_weekly AS
SELECT DATE_TRUNC('week', signup_month)                              AS week,
       device,
       COUNT(*) FILTER (WHERE profile_completed = 1)                 AS reached_step,
       COUNT(*) FILTER (WHERE listing_connected = 1)                 AS completed_step,
       ROUND(100.0 * COUNT(*) FILTER (WHERE listing_connected = 1)
             / NULLIF(COUNT(*) FILTER (WHERE profile_completed = 1), 0), 2) AS step_conv_pct
FROM   funnel_users
GROUP  BY 1, 2;
