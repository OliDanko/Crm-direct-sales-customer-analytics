# Crm-direct-sales-customer-analytics
Customer segmentation, retention and cross-sell analysis using Excel, Power Query, SQL and Power BI.
# CRM & Direct Sales Customer Analytics

Customer segmentation and campaign targeting project focused on identifying actionable customer audiences for **cross-sell, retention and CRM campaigns**.

The project combines **Excel, Power Query, SQL and Power BI** to transform raw customer data into customer segments, campaign priorities and concrete customer lists that could be used by a CRM or Direct Sales team.

---

## Business Goal

The objective of the project was to answer several practical CRM and Direct Sales questions:

- Which customers should be prioritised for cross-sell campaigns?
- Which valuable customers are at risk and should receive retention activity?
- Does previous campaign engagement help identify more responsive customers?
- How does campaign response differ between customer segments?
- How does purchase-channel behaviour relate to campaign response?
- How can analytical results be converted into an actionable campaign audience?

---

## Tools Used

- **Excel**
- **Power Query**
- **MySQL**
- **Power BI**

---

## Dataset

The analysis is based on the **Customer Personality Analysis** marketing dataset.

After data cleaning, the final dataset contained:

**2,236 customers**

The dataset includes information about:

- customer demographics
- income
- recency
- product spending
- purchase behaviour
- campaign acceptance
- web activity
- customer response

---

## Data Preparation

The data was cleaned and transformed using **Excel and Power Query**.

Main preparation steps included:

- Removing 3 unrealistic `Year_Birth` values
- Removing one extreme Income value
- Keeping 24 missing Income values as null
- Creating `Total_Spend`
- Creating `Total_Purchases`
- Creating number of children
- Calculating previous campaign engagement
- Creating RFM scores
- Creating customer segments
- Creating campaign priority groups
- Creating retention and cross-sell flags
- Identifying preferred purchase channel

---

## RFM Customer Segmentation

Customers were segmented using:

- **Recency**
- **Frequency**
- **Monetary Value**

The following customer segments were created:

| Customer Segment | Customers | Response Rate |
|---|---:|---:|
| Champions | 155 | 34.84% |
| Potential Loyalists | 245 | 26.94% |
| Loyal Customers | 291 | 21.65% |
| New Customers | 280 | 16.43% |
| At Risk | 458 | 11.35% |
| Other | 807 | 6.57% |

The overall historical campaign response rate was:

**14.94%**

---

## Campaign Priority

RFM segmentation was combined with previous campaign engagement to create actionable campaign groups.

| Campaign Priority | Customers | Response Rate |
|---|---:|---:|
| High Priority - Cross-sell | 127 | 58.27% |
| Medium Priority | 122 | 45.08% |
| High Priority - Retention | 133 | 27.07% |
| Low Priority | 1,854 | 9.12% |

The **High Priority Cross-sell** group achieved a historical response rate of **58.27%**, compared with only **9.12%** for the Low Priority group.

This is approximately **6.4× higher**.

---

## Cross-sell Analysis

The High Priority Cross-sell group contained:

**127 customers**

A more specific product opportunity was then analysed.

Customers with:

- high Wine spend
- relatively low Meat spend
- High Priority Cross-sell status

were selected as potential **Wine → Meat cross-sell candidates**.

The final cross-sell rule identified:

**10 customers**

Historical performance of this group:

- Responders: **7**
- Response Rate: **70.00%**

Because this audience contains only 10 customers, the result should be interpreted carefully.

---

## Retention Analysis

The High Priority Retention group contained:

**133 customers**

A further value-based rule was used to prioritise the most valuable customers for win-back activity.

This created:

**44 Priority Win-back customers**

Historical response performance:

| Group | Customers | Response Rate |
|---|---:|---:|
| Other High Priority Retention | 89 | 25.84% |
| Priority Win-back | 44 | 29.55% |

The purpose of the retention flag is primarily to prioritise **high-value customers**, rather than to create a strong predictive response model.

---

## Purchase Channel Analysis

Customers were assigned a preferred purchase channel based on their purchasing behaviour.

| Preferred Purchase Channel | Customers | Response Rate |
|---|---:|---:|
| Catalog | 136 | 34.56% |
| Web | 325 | 24.31% |
| Mixed | 298 | 19.13% |
| Store | 1,477 | 10.22% |

`Preferred_Channel` represents the customer's **purchase behaviour**, not their preferred communication channel.

Channel response also differed between campaign audiences.

For example, within the High Priority Cross-sell group, customers classified as Web customers achieved a historical response rate of approximately **75%**.

---

## SQL Analysis

SQL was used to reproduce and operationalise the analytical logic.

The SQL part of the project includes:

- customer filtering with `WHERE`
- aggregations using `COUNT`, `SUM` and `AVG`
- campaign performance analysis with `GROUP BY`
- targeting logic using `CASE WHEN`
- retention audience selection
- cross-sell audience selection
- purchase-channel analysis
- creation of an actionable campaign audience
- creation of a reusable SQL view
- customer prioritisation using `ORDER BY`

Example business logic:

```sql
SELECT
    campaign_priority,
    COUNT(*) AS customers,
    SUM(response) AS responders,
    ROUND(AVG(response) * 100, 2) AS response_rate_pct
FROM marketing
GROUP BY campaign_priority
ORDER BY response_rate_pct DESC;
```

The full SQL analysis is available here:

[`sql/marketing_analysis.sql`](sql/marketing_analysis.sql)

---

## Power BI Dashboard

The final dashboard contains three pages:

### 1. Campaign Overview

Provides an overview of:

- total customers
- overall campaign response rate
- RFM customer segments
- campaign priorities
- response rate by purchase channel

![Campaign Overview](images/campaign_overview.png)

---

### 2. Retention Analysis

Focuses on:

- High Priority Retention customers
- Priority Win-back customers
- historical response comparison
- customer value
- detailed retention customer list

![Retention Analysis](images/retention_analysis.png)

---

### 3. Cross-sell Analysis

Focuses on:

- High Priority Cross-sell customers
- product-level cross-sell opportunities
- cross-sell candidates
- channel performance
- detailed candidate list

![Cross-sell Analysis](images/cross_sell_analysis.png)

---

## Key Results

| KPI | Result |
|---|---:|
| Customers analysed | 2,236 |
| Overall response rate | 14.94% |
| High Priority Cross-sell customers | 127 |
| Cross-sell response rate | 58.27% |
| High Priority Retention customers | 133 |
| Priority Win-back customers | 44 |
| Priority Win-back response rate | 29.55% |
| Product cross-sell candidates | 10 |
| Cross-sell candidate response rate | 70.00% |

---

## Project Workflow

```text
Raw Customer Data
        ↓
Data Cleaning
        ↓
Feature Engineering
        ↓
RFM Segmentation
        ↓
Campaign Engagement Analysis
        ↓
Campaign Priority
        ↓
Cross-sell / Retention Targeting
        ↓
SQL Audience Selection
        ↓
Power BI Dashboard
```

---

## Business Interpretation

The analysis demonstrates how customer data can be transformed into actionable CRM audiences.

Instead of using the same campaign for the entire customer base, customers can be divided into groups with different business objectives:

- **Cross-sell** for engaged and valuable customers
- **Retention / Win-back** for valuable customers showing inactivity
- **Nurture** for customers with moderate potential
- Standard communication for lower-priority customers

The final SQL audience can therefore serve as a simplified example of a customer selection that could be provided to a CRM or campaign management team.

---

## Limitations

This project is based on historical customer data.

Campaign response rates represent **retrospective, in-sample analysis**.

They should therefore not be interpreted as:

- causal effects
- future campaign guarantees
- production predictive model performance

The cross-sell candidate audience is also small (`n = 10`), so the 70% historical response rate should be interpreted with caution.

---

## Skills Demonstrated

**Data preparation:** Excel, Power Query  
**Data analysis:** RFM segmentation, customer behaviour, campaign analysis  
**SQL:** filtering, aggregation, CASE WHEN, GROUP BY, views  
**Visualisation:** Power BI  
**Business analysis:** CRM targeting, retention, cross-sell, customer prioritisation
