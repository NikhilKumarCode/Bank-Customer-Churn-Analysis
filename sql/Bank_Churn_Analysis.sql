-- Bank Customer Churn Analysis
-- SQL Portfolio Project


-- Question 1: What is the overall customer churn rate?

SELECT 
    Attrition_Flag,
    COUNT(*) AS Customer_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_churn_cleaned), 2) AS Percentage
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Overall customer churn is 16.07%, with 1,627 attrited customers.
-- Existing customers represent 83.93% of the customer base.


-- Question 2: Does churn vary by gender? 

SELECT
    Gender,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Gender;
-- Finding:
-- Female customers have a slightly higher churn rate (17.36%)
-- than male customers (14.62%).


-- Question 3: Which education levels have the highest churn rates?

SELECT
    Education_Level,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Education_Level
ORDER BY Churn_Rate DESC;
-- Finding:
-- Doctorate customers have the highest churn rate at 21.06%, followed by
-- Post-Graduate customers at 17.83%. College and High School customers
-- have the lowest churn rates at 15.20%.


-- Question 4: Which income groups have the highest churn rates?

SELECT
    Income_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Income_Category
ORDER BY Churn_Rate DESC;
-- Finding:
-- The $120K+ income group has the highest churn rate at 17.33%, closely
-- followed by customers earning less than $40K at 17.19%.
-- The $60K-$80K group has the lowest churn rate at 13.48%.


-- Question 5: How does churn vary by relationship count?

SELECT
    Total_Relationship_Count,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Total_Relationship_Count
ORDER BY Total_Relationship_Count;
-- Finding:
-- Customers with 2 banking relationships have the highest churn rate at 27.84%,
-- followed by customers with 1 relationship at 25.60%.
-- Churn generally decreases as the number of banking relationships increases,
-- reaching its lowest rate of 10.50% among customers with 6 relationships.


-- Question 6: How does customer inactivity affect churn?

SELECT
    Months_Inactive_12_mon,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Months_Inactive_12_mon
ORDER BY Months_Inactive_12_mon;
-- Finding:
-- Churn increases from 4.48% at 1 month of inactivity to 29.89% at 4 months,
-- suggesting that increasing inactivity is associated with higher churn.
-- The 0-month group has a 51.72% churn rate but contains only 29 customers,
-- so this result should be interpreted cautiously.


-- Question 7: How does contact frequency affect churn?

SELECT
    Contacts_Count_12_mon,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Contacts_Count_12_mon
ORDER BY Contacts_Count_12_mon;
-- Finding:
-- Churn increases steadily as customer contact frequency rises, from 1.75%
-- for customers with 0 contacts to 33.52% for customers with 5 contacts.
-- Customers with 6 contacts have a 100% churn rate, but this group contains
-- only 54 customers, so the result should be interpreted cautiously.


-- Question 8: How does transaction count affect churn?

SELECT
    CASE
        WHEN Total_Trans_Ct <= 30 THEN '0-30'
        WHEN Total_Trans_Ct <= 50 THEN '31-50'
        WHEN Total_Trans_Ct <= 70 THEN '51-70'
        WHEN Total_Trans_Ct <= 90 THEN '71-90'
        WHEN Total_Trans_Ct <= 110 THEN '91-110'
        ELSE '111-140'
    END AS Transaction_Count_Group,
    
    COUNT(*) AS Total_Customers,
    
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate

FROM bank_churn_cleaned

GROUP BY Transaction_Count_Group

ORDER BY MIN(Total_Trans_Ct);
-- Finding:
-- Customers with 31-50 transactions have the highest churn rate at 40.45%.
-- Churn decreases substantially as transaction activity increases,
-- suggesting that higher transaction activity is associated with lower churn.


-- Question 9: How does transaction amount affect churn?

SELECT
    CASE
        WHEN Total_Trans_Amt <= 2000 THEN '0-2000'
        WHEN Total_Trans_Amt <= 4000 THEN '2001-4000'
        WHEN Total_Trans_Amt <= 6000 THEN '4001-6000'
        WHEN Total_Trans_Amt <= 8000 THEN '6001-8000'
        WHEN Total_Trans_Amt <= 10000 THEN '8001-10000'
        ELSE '10001+'
    END AS Transaction_Amount_Group,

    COUNT(*) AS Total_Customers,

    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,

    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate

FROM bank_churn_cleaned

GROUP BY Transaction_Amount_Group

ORDER BY MIN(Total_Trans_Amt);
-- Finding:
-- Churn varies considerably across transaction amount groups and does not
-- follow a consistent increasing or decreasing pattern. Customers with
-- transaction amounts of 8001-10000 have the highest churn rate at 43.20%.
-- This suggests that transaction amount has a non-linear relationship with churn.


-- Question 10: How does credit utilization affect churn?

SELECT
    CASE
        WHEN Avg_Utilization_Ratio = 0 THEN '0'
        WHEN Avg_Utilization_Ratio <= 0.20 THEN '0.01-0.20'
        WHEN Avg_Utilization_Ratio <= 0.40 THEN '0.21-0.40'
        WHEN Avg_Utilization_Ratio <= 0.60 THEN '0.41-0.60'
        WHEN Avg_Utilization_Ratio <= 0.80 THEN '0.61-0.80'
        ELSE '0.81-1.00'
    END AS Utilization_Group,

    COUNT(*) AS Total_Customers,

    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,

    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate

FROM bank_churn_cleaned

GROUP BY Utilization_Group

ORDER BY MIN(Avg_Utilization_Ratio);
-- Finding:
-- Customers with zero credit utilization have the highest churn rate at 36.15%.
-- Churn is much lower among customers with moderate utilization, but rises again
-- to 20.34% for customers with utilization between 0.81 and 1.00.
-- This suggests a non-linear relationship between credit utilization and churn.


-- Question 11: How does revolving balance differ between attrited and existing customers?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Revolving_Bal), 2) AS Avg_Revolving_Balance,
    MIN(Total_Revolving_Bal) AS Min_Revolving_Balance,
    MAX(Total_Revolving_Bal) AS Max_Revolving_Balance
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Attrited customers have a substantially lower average revolving balance
-- of 672.82 compared with 1,256.60 for existing customers.
-- This suggests that lower revolving balances are associated with customer churn.


-- Question 12: How does transaction count change differ by churn status?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Ct_Chng_Q4_Q1), 3) AS Avg_Transaction_Count_Change,
    ROUND(MIN(Total_Ct_Chng_Q4_Q1), 3) AS Min_Transaction_Count_Change,
    ROUND(MAX(Total_Ct_Chng_Q4_Q1), 3) AS Max_Transaction_Count_Change
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Attrited customers have a lower average transaction count change ratio
-- of 0.554 compared with 0.742 for existing customers.
-- This suggests that declining transaction activity may be associated with churn.


-- Question 13: How does transaction amount change differ by churn status?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Amt_Chng_Q4_Q1), 3) AS Avg_Transaction_Amount_Change,
    ROUND(MIN(Total_Amt_Chng_Q4_Q1), 3) AS Min_Transaction_Amount_Change,
    ROUND(MAX(Total_Amt_Chng_Q4_Q1), 3) AS Max_Transaction_Amount_Change
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Attrited customers have a lower average transaction amount change ratio
-- of 0.694 compared with 0.773 for existing customers.
-- This suggests that lower transaction amount growth may be associated with churn,
-- although the difference is less pronounced than transaction count change.


-- Question 14: What is the churn rate among customers with multiple high-risk behaviours?

SELECT
    COUNT(*) AS High_Risk_Customers,
    
    SUM(CASE 
        WHEN Attrition_Flag = 'Attrited Customer' THEN 1 
        ELSE 0 
    END) AS Attrited_Customers,
    
    ROUND(SUM(CASE 
            WHEN Attrition_Flag = 'Attrited Customer' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS Churn_Rate

FROM bank_churn_cleaned

WHERE Total_Trans_Ct <= 50
    AND Total_Relationship_Count <= 2
    AND Contacts_Count_12_mon >= 3
    AND Months_Inactive_12_mon >= 3;
-- Finding:
-- 178 customers met all four high-risk behavioural conditions, and 172 of them
-- had churned, resulting in a churn rate of 96.63%.
-- This suggests that combining multiple behavioural indicators can identify
-- a customer segment with a very high concentration of churn.


-- Question 15: How does churn compare between high-risk customers and other customers?

SELECT
    CASE
        WHEN Total_Trans_Ct <= 50
            AND Total_Relationship_Count <= 2
            AND Contacts_Count_12_mon >= 3
            AND Months_Inactive_12_mon >= 3
        THEN 'High Risk'
        ELSE 'Other Customers'
    END AS Risk_Group,

    COUNT(*) AS Total_Customers,

    SUM(CASE
        WHEN Attrition_Flag = 'Attrited Customer' THEN 1
        ELSE 0
    END) AS Attrited_Customers,

    ROUND(SUM(CASE
            WHEN Attrition_Flag = 'Attrited Customer' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*), 2) AS Churn_Rate

FROM bank_churn_cleaned

GROUP BY Risk_Group;
-- Finding:
-- Customers classified as High Risk have a churn rate of 96.63%,
-- compared with 14.62% among other customers.
-- This suggests that combining multiple behavioural indicators can identify
-- a segment with a very high concentration of churn.


-- Question 16: Which customers meet all four high-risk behavioural conditions?

SELECT
    CLIENTNUM,
    Attrition_Flag,
    Total_Trans_Ct,
    Total_Relationship_Count,
    Contacts_Count_12_mon,
    Months_Inactive_12_mon
FROM bank_churn_cleaned
WHERE Total_Trans_Ct <= 50
    AND Total_Relationship_Count <= 2
    AND Contacts_Count_12_mon >= 3
    AND Months_Inactive_12_mon >= 3
ORDER BY Total_Trans_Ct ASC;
-- Finding:
-- The query identified 178 customers who met all four high-risk behavioural
-- conditions. Most of these customers were attrited, supporting the earlier
-- finding that this combination of behaviours is strongly associated with churn.

-- Question 17: How does churn change as the number of behavioural risk indicators increases?

SELECT
    Risk_Indicator_Count,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate

FROM (
    SELECT
        Attrition_Flag,

        (CASE WHEN Total_Trans_Ct <= 50 THEN 1 ELSE 0 END +
         CASE WHEN Total_Relationship_Count <= 2 THEN 1 ELSE 0 END +
         CASE WHEN Contacts_Count_12_mon >= 3 THEN 1 ELSE 0 END +
         CASE WHEN Months_Inactive_12_mon >= 3 THEN 1 ELSE 0 END) AS Risk_Indicator_Count

    FROM bank_churn_cleaned
)

GROUP BY Risk_Indicator_Count
ORDER BY Risk_Indicator_Count;
-- Finding:
-- Churn increases substantially as customers accumulate more behavioural
-- risk indicators, rising from 1.57% with 0 indicators to 6.24% with 1,
-- 18.33% with 2, 48.36% with 3, and 96.63% with all 4 indicators.
-- This suggests that combining behavioural signals can help identify
-- customer segments with substantially higher churn risk.

-- Question 18: How does credit limit differ between attrited and existing customers?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Credit_Limit), 2) AS Avg_Credit_Limit,
    ROUND(MIN(Credit_Limit), 2) AS Min_Credit_Limit,
    ROUND(MAX(Credit_Limit), 2) AS Max_Credit_Limit
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Attrited customers have a slightly lower average credit limit of 8,136.04
-- compared with 8,726.88 for existing customers.
-- The difference is relatively modest, suggesting that credit limit alone
-- is not a strong churn differentiator.

-- Question 19: How does Average Open to Buy differ between attrited and existing customers?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Avg_Open_To_Buy), 2) AS Avg_Open_To_Buy,
    ROUND(MIN(Avg_Open_To_Buy), 2) AS Min_Open_To_Buy,
    ROUND(MAX(Avg_Open_To_Buy), 2) AS Max_Open_To_Buy
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Average Open to Buy is almost identical between attrited and existing customers at 7,463.22 and 7,470.27 respectively.
-- This suggests that Average Open to Buy alone provides little
-- differentiation between customers who churn and those who remain.


-- Question 20: How does average transaction activity differ between attrited and existing customers?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Trans_Ct), 2) AS Avg_Transaction_Count,
    ROUND(AVG(Total_Trans_Amt), 2) AS Avg_Transaction_Amount
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Attrited customers have lower average transaction activity, with an average transaction count of 44.93 compared with 68.67 for existing customers.
-- Their average transaction amount is also lower at 3,095.03 compared with
-- 4,654.66 for existing customers.
-- This suggests that lower customer transaction activity is associated with churn.


-- Question 21: How does churn vary across different card categories?

SELECT
    Card_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Attrited_Customers,
    ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bank_churn_cleaned
GROUP BY Card_Category
ORDER BY Churn_Rate DESC;
-- Finding:
-- Platinum customers have the highest churn rate at 25.00%, followed by
-- Gold customers at 18.10%. However, the Platinum and Gold categories contain
-- only 20 and 116 customers respectively, so their churn rates should be
-- interpreted cautiously due to the small sample sizes.


-- Question 22: How does customer tenure differ between attrited and existing customers?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Months_on_book), 2) AS Avg_Months_On_Book,
    MIN(Months_on_book) AS Min_Months_On_Book,
    MAX(Months_on_book) AS Max_Months_On_Book
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Customer tenure is almost identical between attrited and existing customers, with average tenures of 36.18 and 35.88 months respectively.
-- This suggests that customer tenure alone is not a strong churn indicator.


-- Question 23: How does customer age differ between attrited and existing customers?

SELECT
    Attrition_Flag,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Customer_Age), 2) AS Avg_Customer_Age,
    MIN(Customer_Age) AS Min_Customer_Age,
    MAX(Customer_Age) AS Max_Customer_Age
FROM bank_churn_cleaned
GROUP BY Attrition_Flag;
-- Finding:
-- Attrited and existing customers have very similar average ages at 46.66 and 46.26 years respectively.
-- This suggests that customer age alone is not a strong churn indicator.


-- Question 24: Which behavioural risk-indicator groups contribute the most to total churn?

WITH Risk_Groups AS (
    SELECT
        Attrition_Flag,

        (CASE WHEN Total_Trans_Ct <= 50 THEN 1 ELSE 0 END +
         CASE WHEN Total_Relationship_Count <= 2 THEN 1 ELSE 0 END +
         CASE WHEN Contacts_Count_12_mon >= 3 THEN 1 ELSE 0 END +
         CASE WHEN Months_Inactive_12_mon >= 3 THEN 1 ELSE 0 END) AS Risk_Indicator_Count

    FROM bank_churn_cleaned
)

SELECT
    Risk_Indicator_Count,
    COUNT(*) AS Total_Customers,

    SUM(CASE
        WHEN Attrition_Flag = 'Attrited Customer' THEN 1
        ELSE 0
    END) AS Attrited_Customers,

    ROUND(SUM(CASE
            WHEN Attrition_Flag = 'Attrited Customer' THEN 1
            ELSE 0
        END) * 100.0 /
        (SELECT COUNT(*)
         FROM Risk_Groups
         WHERE Attrition_Flag = 'Attrited Customer'), 2) AS Share_Of_Total_Churn

FROM Risk_Groups

GROUP BY Risk_Indicator_Count
ORDER BY Risk_Indicator_Count;
-- Finding:
-- Customers with 2 risk indicators contribute the largest share of total churn at 37.80%, followed by customers with 3 indicators at 35.28%.
-- Together, these two groups account for 73.08% of all attrited customers.
-- Although customers with 4 indicators have the highest churn rate, they represent only 10.57% of total churn because the group is relatively small.


-- Question 25: Which existing customers currently show the strongest behavioural churn warning signals?

WITH Customer_Risk AS (
    SELECT
        CLIENTNUM,
        Attrition_Flag,
        Total_Trans_Ct,
        Total_Relationship_Count,
        Contacts_Count_12_mon,
        Months_Inactive_12_mon,

        (CASE WHEN Total_Trans_Ct <= 50 THEN 1 ELSE 0 END +
         CASE WHEN Total_Relationship_Count <= 2 THEN 1 ELSE 0 END +
         CASE WHEN Contacts_Count_12_mon >= 3 THEN 1 ELSE 0 END +
         CASE WHEN Months_Inactive_12_mon >= 3 THEN 1 ELSE 0 END) AS Risk_Indicator_Count

    FROM bank_churn_cleaned
)

SELECT
    CLIENTNUM,
    Total_Trans_Ct,
    Total_Relationship_Count,
    Contacts_Count_12_mon,
    Months_Inactive_12_mon,
    Risk_Indicator_Count

FROM Customer_Risk

WHERE Attrition_Flag = 'Existing Customer'
    AND Risk_Indicator_Count >= 3

ORDER BY Risk_Indicator_Count DESC, Total_Trans_Ct ASC;
-- Finding:
-- 619 existing customers currently show at least 3 behavioural risk indicators.
-- Among them, 6 customers show all 4 risk indicators.
-- These customers could represent priority segments for targeted retention efforts,
-- although the risk indicators are descriptive and should not be treated as a predictive churn model.

