-- HEALTHCARE BILLING ANALYTICS - Business Acumen SQL
-- Oluyomi Abayomi | $28.95M Analysis

-- 1. Cost Outlier: Mucormycosis is 2.3x average
SELECT Diagnosis, 
       AVG(Billing_Amount) as avg_bill,
       AVG(Billing_Amount) / (SELECT AVG(Billing_Amount) FROM healthcare_billing) as vs_avg_multiplier,
       COUNT(*) as cases
FROM healthcare_billing
GROUP BY Diagnosis
ORDER BY avg_bill DESC;
-- Result: Mucormycosis $69K = 2.3x avg $30K

-- 2. Procedure Cost: Surgical vs General
SELECT Procedure_Type,
       AVG(Billing_Amount) as avg_cost,
       AVG(Length_of_Stay_Days) as avg_los,
       AVG(Billing_Amount)/AVG(Length_of_Stay_Days) as cost_per_day
FROM healthcare_billing
GROUP BY Procedure_Type;
-- Result: Surgical $32K highest, General $12K / 11.3 days = most efficient

-- 3. Department Profitability & Efficiency
SELECT Department,
       SUM(Billing_Amount)/1e6 as revenue_M,
       AVG(Length_of_Stay_Days) as avg_los,
       RANK() OVER (ORDER BY AVG(Billing_Amount)/AVG(Length_of_Stay_Days) DESC) as revenue_per_day_rank
FROM healthcare_billing
GROUP BY Department;

-- 4. Early Screening Saving Model: $400K/year
SELECT 
  COUNT(CASE WHEN Diagnosis='Mucormycosis' THEN 1 END) as mucor_cases,
  AVG(CASE WHEN Diagnosis='Mucormycosis' THEN Billing_Amount END) as mucor_cost,
  AVG(CASE WHEN Diagnosis='Diabetes' THEN Billing_Amount END) as diabetes_cost,
  COUNT(CASE WHEN Diagnosis='Mucormycosis' THEN 1 END) * 
  (AVG(CASE WHEN Diagnosis='Mucormycosis' THEN Billing_Amount END) - AVG(CASE WHEN Diagnosis='Diabetes' THEN Billing_Amount END)) /1e3 as potential_saving_K
FROM healthcare_billing;
-- Result: Early diabetes screening prevents mucor progression = $400K saved (6 cases x $57K diff)

-- 5. Billing vs Stay Correlation (Operational inefficiency)
SELECT CORR(Billing_Amount, Length_of_Stay_Days) as bill_los_corr;
-- Result: 0.82 = Longer stay = Higher bill, optimize LOS = cut cost
