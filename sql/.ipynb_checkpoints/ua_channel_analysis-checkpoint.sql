-- ================================================
-- UA CHANNEL ANALYSIS
-- Dataset: Global Ads Performance (Google/Meta/TikTok)
-- ================================================

-- 1. Overall Platform Performance
SELECT
    platform,
    COUNT(*) AS total_campaigns,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue) / SUM(ad_spend), 2) AS overall_ROAS,
    ROUND(SUM(ad_spend) / SUM(conversions), 2) AS CPA,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS CTR_pct,
    ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) AS CVR_pct
FROM ads_performance
GROUP BY platform
ORDER BY overall_ROAS DESC;

-- 2. Best Performing Campaign Types per Platform
SELECT
    platform,
    campaign_type,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(AVG(ROAS), 2) AS avg_ROAS,
    ROUND(AVG(CPA), 2) AS avg_CPA,
    SUM(conversions) AS total_conversions
FROM ads_performance
GROUP BY platform, campaign_type
ORDER BY platform, avg_ROAS DESC;

-- 3. Monthly Spend & ROAS Trend
SELECT
    strftime('%Y-%m', date) AS month,
    platform,
    ROUND(SUM(ad_spend), 2) AS monthly_spend,
    ROUND(AVG(ROAS), 2) AS avg_ROAS,
    SUM(conversions) AS monthly_conversions
FROM ads_performance
GROUP BY month, platform
ORDER BY month, platform;

-- 4. Top 10 Most Efficient Campaigns (highest ROAS, lowest CPA)
SELECT
    platform,
    campaign_type,
    country,
    ROUND(ad_spend, 2) AS spend,
    conversions,
    ROUND(ROAS, 2) AS ROAS,
    ROUND(CPA, 2) AS CPA
FROM ads_performance
WHERE conversions > 0
ORDER BY ROAS DESC, CPA ASC
LIMIT 10;

-- 5. Budget Efficiency: Spend vs Revenue by Platform
SELECT
    platform,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / SUM(ad_spend), 2) AS overall_ROAS,
    ROUND((SUM(revenue) - SUM(ad_spend)), 2) AS net_profit
FROM ads_performance
GROUP BY platform
ORDER BY overall_ROAS DESC;