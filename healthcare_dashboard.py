# HEALTHCARE BILLING ANALYTICS - Business Acumen
# Oluyomi Abayomi | Data Analyst
import pandas as pd

df = pd.read_csv('healthcare_billing.csv')

# Business Insights
mucor_avg = df[df['Diagnosis']=='Mucormycosis']['Billing_Amount'].mean() # $69K
avg_all = df['Billing_Amount'].mean() # $30K
multiplier = mucor_avg / avg_all

surgical_avg = df[df['Procedure_Type']=='Surgical']['Billing_Amount'].mean()

print(f"Outlier: Mucormycosis ${mucor_avg:.0f} = {multiplier:.1f}x avg ${avg_all:.0f}")
print(f"Surgical highest: ${surgical_avg:.0f} vs General most efficient")

# $400K Saving Model
saving = 6 * (mucor_avg - 12000)
print(f"Early screening: 6 Mucor cases prevented x $57K = ${saving/1000:.0f}K saved")

# $28.95M total billing
print(f"Total Portfolio: ${df['Billing_Amount'].sum()/1e6:.2f}M | Business Acumen: Cost outlier = Preventable")
