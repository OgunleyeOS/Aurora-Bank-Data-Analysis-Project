SELECT *
FROM users_dataaa;

-- Disable Safe Update Mode
SET SQL_SAFE_UPDATES = 0;

-- Use the REPLACE function to remove '$', ','
UPDATE users_dataaa
SET per_capita_income = REPLACE(per_capita_income, '$', ''),
	per_capita_income = REPLACE(per_capita_income, ',', ''),
    yearly_income = REPLACE(yearly_income, '$', ''),
    yearly_income = REPLACE(yearly_income, ',', ''),
    total_debt = REPLACE(total_debt, ',', ''),
    total_debt = REPLACE(total_debt, '$', '');
    
SELECT count(*) AS total_customers FROM users_dataaa; 
SELECT avg (yearly_income), sum(yearly_income) FROM users_dataaa;
SELECT avg (credit_score), sum(total_debt) FROM users_dataaa;

-- Financial Health Analysis
-- Calculate Debt-to-Income (DTI) Ratio
ALTER TABLE users_dataaa
ADD COLUMN dti_ratio DECIMAL(10, 2);

UPDATE users_dataaa
SET dti_ratio = total_debt / yearly_income;

-- Segment Customers by Risk Level
ALTER TABLE users_dataaa
ADD COLUMN risk_level VARCHAR(20);

UPDATE users_dataaa
SET risk_level = CASE
    WHEN dti_ratio < 0.2 THEN 'Low Risk'
    WHEN dti_ratio BETWEEN 0.2 AND 0.4 THEN 'Moderate Risk'
    WHEN dti_ratio BETWEEN 0.4 AND 0.6 THEN 'High Risk'
    ELSE 'Critical Risk'
END;

-- Customer Segmentation by Risk Level or Customer Risk Distribution
SELECT risk_level, COUNT(*) AS num_customers
FROM users_dataaa
GROUP BY risk_level;

-- Age and Gender Distribution
SELECT gender, 
       CASE 
           WHEN current_age BETWEEN 18 AND 24 THEN '18-24'
           WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
           WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
           WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
           WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
           ELSE '65+' 
       END AS age_group, 
       COUNT(*) AS total_customers
FROM users_dataaa
GROUP BY gender, age_group
ORDER BY age_group asc;

-- Credit Score Distribution
SELECT CASE 
           WHEN credit_score < 600 THEN 'Poor'
           WHEN credit_score BETWEEN 600 AND 699 THEN 'Fair'
           WHEN credit_score BETWEEN 700 AND 799 THEN 'Good'
           ELSE 'Excellent' 
       END AS credit_rating, 
       COUNT(*) AS customer_count
FROM users_dataaa
GROUP BY credit_rating
ORDER BY credit_rating;

-- Card Ownership by Demographics
SELECT age_group, gender, AVG(num_credit_cards) AS avg_cards_per_customer
FROM (
    SELECT gender, 
           CASE 
               WHEN current_age BETWEEN 18 AND 24 THEN '18-24'
               WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
               WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
               WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
               ELSE '55+' 
           END AS age_group, 
           num_credit_cards
    FROM users_dataaa
) AS demographic_data
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- Debt Distribution
SELECT gender, 
CASE 
           WHEN total_debt < 10000 THEN 'Low Debt'
           WHEN total_debt BETWEEN 10000 AND 50000 THEN 'Medium Debt'
           ELSE 'High Debt' 
       END AS debt_level, 
   CASE 
               WHEN current_age BETWEEN 18 AND 24 THEN '18-24'
               WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
               WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
               WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
               WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
           ELSE '65+' 
           END AS age_group, 
       COUNT(*) AS customer_count
FROM users_dataaa
GROUP BY gender, age_group, debt_level
ORDER BY customer_count DESC;

select avg(dti_ratio),
   CASE 
               WHEN current_age BETWEEN 18 AND 24 THEN '18-24'
               WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
               WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
               WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
               WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
           ELSE '65+' 
           END AS age_group
FROM users_dataaa
GROUP BY age_group
ORDER BY age_group DESC;


select * from cards_data;

select card_brand, card_type, count(*), sum(t.amount)
from cards_data c
INNER JOIN transactions_data t on t.card_id = c.id
GROUP BY card_brand, card_type
ORDER BY card_brand;

SELECT merchant_city, count(*) 
FROM transactions_data
GROUP BY merchant_city;

SELECT Description
FROM mcc_codes
INNER JOIN 


SELECT gender,
CASE 
           WHEN total_debt < 10000 THEN 'Low Debt'
           WHEN total_debt BETWEEN 10000 AND 50000 THEN 'Medium Debt'
           ELSE 'High Debt' 
       END AS debt_level, 
   CASE 
               WHEN current_age BETWEEN 18 AND 24 THEN '18-24'
               WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
               WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
               WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
               ELSE '55+' 
           END AS age_group, 
       COUNT(*) AS customer_count
FROM users_dataaa
GROUP BY gender, age_group, debt_level
ORDER BY customer_count DESC;

SELECT *
FROM transactions_data;

SELECT sum(amount)
FROM transactions_data;

-- Debt Levels by Risk Category
SELECT 
    CASE 
        WHEN credit_score < 580 THEN 'High Risk'
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Category,
    SUM(total_debt) AS Total_Debt
FROM 
    users_dataaa
GROUP BY 
    Risk_Category
ORDER BY 
    Total_Debt DESC;

--  Failed Transaction Trends by Region
SELECT 
    users_dataaa.address AS Region,
    COUNT(transactions_data.client_id) AS Failed_Transactions
FROM 
    transactions_data
JOIN 
    users_dataaa ON transactions_data.client_id = users_dataaa.id

GROUP BY 
    Region
ORDER BY 
    Failed_Transactions DESC;
    
-- DTI Ratio vs. Credit Score    
SELECT 
    users_dataaa.id,
    users_dataaa.credit_score,
    CASE 
        WHEN credit_score < 580 THEN 'High Risk'
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Category,
    (users_dataaa.total_debt / users_dataaa.yearly_income) AS DTI_Ratio
FROM 
    users_dataaa
WHERE 
    yearly_income > 0
ORDER BY 
    DTI_Ratio DESC;

-- High-Value Transactions
    SELECT 
    id,
    client_id,
    sum(amount) as amount
FROM 
    transactions_data
WHERE 
	amount > (SELECT AVG(amount) FROM transactions_data)
group by id, client_id,amount
ORDER BY 
    amount DESC;
    
    
SELECT SUM(amount)
FROM transactions_data;

-- Spending by Merchant Category (MCC)
SELECT 
    mcc_codes.description AS Merchant_Category,
    SUM(transactions_data.amount) AS Total_Spending
FROM 
    transactions_data
JOIN 
    mcc_codes ON transactions_data.mcc = mcc_codes.mcc_id
GROUP BY 
    mcc_codes.description
ORDER BY 
    Total_Spending DESC;

SELECT 
    SUM(transactions_data.amount) AS Total_Spending
FROM 
    transactions_data; 