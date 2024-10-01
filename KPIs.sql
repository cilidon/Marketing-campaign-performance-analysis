SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131` LIMIT 1000;


SELECT distinct event_name FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131` LIMIT 1000;

SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131` where event_name = 'purchase' LIMIT 1000;


-- TOtal users

SELECT 
  COUNT(DISTINCT user_pseudo_id) as total_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


-- Total Sessions

SELECT 
  COUNT(DISTINCT (CONCAT(user_pseudo_id, CAST(event_timestamp AS STRING)))) as total_sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'session_start';


-- conversion Rate

WITH purchases AS (
  SELECT 
    COUNT(DISTINCT user_pseudo_id) as users_who_purchased
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE event_name = 'purchase'
),
total_users AS (
  SELECT 
    COUNT(DISTINCT user_pseudo_id) as total_users
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)
SELECT 
  ROUND(purchases.users_who_purchased / total_users.total_users * 100, 2) as conversion_rate
FROM purchases, total_users;

-- Average Order Value

SELECT 
  ROUND(AVG(ecommerce.purchase_revenue), 2) as avg_order_value
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase';

-- Revenue by campaign

SELECT 
  traffic_source.medium as campaign,
  ROUND(SUM(ecommerce.purchase_revenue), 2) as total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
GROUP BY traffic_source.medium
ORDER BY total_revenue DESC
LIMIT 5;
