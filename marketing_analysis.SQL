/*
===========================================================
CRM & DIRECT SALES CUSTOMER ANALYSIS
===========================================================

Business goal:
- Identify customers for retention and cross-sell campaigns
- Evaluate campaign response by customer segment
- Analyse purchase-channel behaviour
- Create an actionable audience for campaign managers

Main use cases:
1. Retention audience
2. Cross-sell audience
3. Campaign performance
4. Campaign priority logic
5. Campaign action list
6. Purchase-channel analysis

Dataset:
- 2,236 customers
- Cleaned and segmented in Excel / Power Query
===========================================================
*/


/* ========================================================
   1. RETENTION AUDIENCE
   ========================================================

   Goal:
   Select the highest-value customers from the
   High Priority Retention audience.

   Retention_Flag = 1 represents the top-value group
   selected for priority win-back activity.

   Expected audience size: 44 customers
*/


-- Detailed retention customer list
SELECT
    id,
    customer_segment,
    campaign_priority,
    total_spend,
    retention_flag,
    preferred_channel,
    response
FROM marketing
WHERE retention_flag = 1;


-- Check retention audience size
SELECT
    COUNT(*) AS retention_customers
FROM marketing
WHERE retention_flag = 1;


-- Retention audience performance
SELECT
    COUNT(*) AS retention_customers,
    SUM(response) AS responders,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
WHERE retention_flag = 1;

/*
Expected result:
- Customers: 44
- Responders: 13
- Response Rate: 29.55%
*/


/* ========================================================
   2. RETENTION PRIORITY COMPARISON
   ========================================================

   Goal:
   Compare high-value retention customers with the
   remaining High Priority Retention audience.
*/


SELECT
    retention_flag,
    COUNT(*) AS customers,
    SUM(response) AS responders,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
WHERE campaign_priority = 'High Priority - Retention'
GROUP BY retention_flag
ORDER BY retention_flag;

/*
Expected result:

Retention_Flag = 0
- 89 customers
- 25.84% response rate

Retention_Flag = 1
- 44 customers
- 29.55% response rate
*/


/* ========================================================
   3. CROSS-SELL AUDIENCE
   ========================================================

   Goal:
   Identify customers selected for the Wine -> Meat
   cross-sell opportunity.

   Expected audience size: 10 customers
*/


-- Detailed cross-sell customer list
SELECT
    id,
    customer_segment,
    campaign_priority,
    mntwines,
    mntmeatproducts,
    total_spend,
    preferred_channel,
    response
FROM marketing
WHERE cross_sell_flag = 1;


-- Check cross-sell audience size
SELECT
    COUNT(*) AS cross_sell_customers
FROM marketing
WHERE cross_sell_flag = 1;


-- Cross-sell audience performance
SELECT
    COUNT(*) AS cross_sell_customers,
    SUM(response) AS responders,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
WHERE cross_sell_flag = 1;

/*
Expected result:
- Customers: 10
- Responders: 7
- Response Rate: 70.00%
*/


/* ========================================================
   4. CROSS-SELL BUSINESS LOGIC IN SQL
   ========================================================

   Rules:
   - High Priority Cross-sell customer
   - Wine spend >= 914.52
   - Meat spend <= 144.58
*/


SELECT
    id,
    customer_segment,
    campaign_priority,
    mntwines,
    mntmeatproducts,
    total_spend,
    preferred_channel,
    response
FROM marketing
WHERE campaign_priority = 'High Priority - Cross-sell'
  AND mntwines >= 914.52
  AND mntmeatproducts <= 144.58;


SELECT
    COUNT(*) AS cross_sell_customers,
    SUM(response) AS responders,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
WHERE campaign_priority = 'High Priority - Cross-sell'
  AND mntwines >= 914.52
  AND mntmeatproducts <= 144.58;


/* ========================================================
   5. CAMPAIGN PRIORITY PERFORMANCE
   ======================================================== */


SELECT
    campaign_priority,
    COUNT(*) AS customers,
    SUM(response) AS responders,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
GROUP BY campaign_priority
ORDER BY response_rate_pct DESC;


/*
Key results:
- High Priority Cross-sell: 127 customers / 58.27%
- Medium Priority: 122 customers / 45.08%
- High Priority Retention: 133 customers / 27.07%
- Low Priority: 1,854 customers / 9.12%
*/


/* ========================================================
   6. RECREATE CAMPAIGN PRIORITY USING CASE WHEN
   ======================================================== */


SELECT
    CASE
        WHEN customer_segment IN ('Champions', 'Potential Loyalists')
             AND previous_campaigns_accepted >= 1
        THEN 'High Priority - Cross-sell'

        WHEN customer_segment = 'At Risk'
             AND previous_campaigns_accepted >= 1
        THEN 'High Priority - Retention'

        WHEN customer_segment IN ('Loyal Customers', 'New Customers')
             AND previous_campaigns_accepted >= 1
        THEN 'Medium Priority'

        ELSE 'Low Priority'
    END AS calculated_campaign_priority,

    COUNT(*) AS customers,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct

FROM marketing

GROUP BY calculated_campaign_priority
ORDER BY response_rate_pct DESC;


/* ========================================================
   7. ACTIONABLE CAMPAIGN AUDIENCE
   ======================================================== */


SELECT
    id AS customer_id,
    customer_segment,
    campaign_priority,
    preferred_channel,
    total_spend,

    CASE
        WHEN campaign_priority = 'High Priority - Cross-sell'
             AND cross_sell_flag = 1
        THEN 'Offer Meat Products'

        WHEN campaign_priority = 'High Priority - Retention'
             AND retention_flag = 1
        THEN 'Priority Win-back'

        WHEN campaign_priority = 'Medium Priority'
        THEN 'Nurture / Follow-up'

        ELSE 'Standard Communication'
    END AS recommended_action

FROM marketing

WHERE cross_sell_flag = 1
   OR retention_flag = 1
   OR campaign_priority = 'Medium Priority'

ORDER BY
    CASE
        WHEN cross_sell_flag = 1 THEN 1
        WHEN retention_flag = 1 THEN 2
        WHEN campaign_priority = 'Medium Priority' THEN 3
        ELSE 4
    END,
    total_spend DESC;


SELECT
    COUNT(*) AS audience_size
FROM marketing
WHERE cross_sell_flag = 1
   OR retention_flag = 1
   OR campaign_priority = 'Medium Priority';

/*
Expected result:
176 customers
*/


/* ========================================================
   8. REUSABLE CAMPAIGN VIEW
   ======================================================== */


CREATE OR REPLACE VIEW vw_campaign_audience AS
SELECT
    id AS customer_id,
    customer_segment,
    campaign_priority,
    preferred_channel,
    total_spend,

    CASE
        WHEN cross_sell_flag = 1
        THEN 'Offer Meat Products'

        WHEN retention_flag = 1
        THEN 'Priority Win-back'

        WHEN campaign_priority = 'Medium Priority'
        THEN 'Nurture / Follow-up'

        ELSE 'Standard Communication'
    END AS recommended_action

FROM marketing

WHERE cross_sell_flag = 1
   OR retention_flag = 1
   OR campaign_priority = 'Medium Priority';


SELECT
    COUNT(*) AS audience_size
FROM vw_campaign_audience;


/* ========================================================
   9. PURCHASE CHANNEL PERFORMANCE
   ========================================================

   Preferred_Channel represents purchase behaviour,
   not communication-channel preference.
*/


SELECT
    campaign_priority,
    preferred_channel,
    COUNT(*) AS customers,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
GROUP BY
    campaign_priority,
    preferred_channel
ORDER BY
    campaign_priority,
    response_rate_pct DESC;


/* ========================================================
   10. PRIORITY RETENTION CONTACT LIST
   ======================================================== */


SELECT
    id,
    customer_segment,
    total_spend,
    previous_campaigns_accepted,
    recency,
    preferred_channel,
    response
FROM marketing
WHERE retention_flag = 1
ORDER BY total_spend DESC;


SELECT
    id,
    total_spend,
    previous_campaigns_accepted,
    recency,
    preferred_channel
FROM marketing
WHERE retention_flag = 1
ORDER BY total_spend DESC
LIMIT 10;
