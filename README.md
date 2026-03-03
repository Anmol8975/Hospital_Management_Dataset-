# Hospital_Management_Dataset-
This project analyzes a Hospital Management Dataset using SQL and Power BI. I performed multi-level data analysis—from basic patient demographics and revenue totals to advanced Patient Lifetime Value (LTV) and doctor performance metrics. The final dashboard visualizes appointment trends, billing leaks, and departmental efficiency.
Annual Healthcare Financial & Operational Analysis

📋 Project Overview
This project provides a 360-degree financial and operational audit of a healthcare system. Using a combination of SQL for deep-dive data engineering and Power BI for interactive storytelling, the analysis tracks revenue trends, patient demographics, and doctor efficiency across multiple hospital branches.

The goal is to identify "Revenue Leakage" (failed/pending payments) and optimize appointment scheduling by analyzing cancellation and no-show rates.

🛠️ Tech Stack
Database: PostgreSQL (Schema Design, Joins, CTEs, Window Functions)

Visualization: Power BI (DAX, Interactive Dashboards)

Data Cleaning: Microsoft Excel

📊 Key Insights from Dashboard

1. Financial Performance
 
* Total Revenue: 551.25K generated in the fiscal year.

* Patient Lifetime Value (LTV): The average LTV stands at 57.26K.

* Revenue Leakage: Significant revenue dips are visible in February and September, correlating with high "Failed or Pending" payment statuses.

* Specialization Leader: Pediatrics is the highest revenue-generating department (1.29M), followed by Dermatology.

2. Operational Efficiency

* Appointment Trends: Peak appointment volume occurred in April 2023 (25 appointments).

* Doctor Workload: Central Hospital and Eastside Clinic lead with an average of 21 appointments per doctor.

* Top Treatment: Chemotherapy is the most frequent treatment type, followed by X-rays.

3. Patient & Insurance Demographics

* Gender Split: The patient base is 62% Male and 38% Female.

* Insurance Risk: MedCare Plus accounts for 50% of all failed or pending insurance payments.

💻 SQL Analysis Highlights

* The project utilizes advanced SQL techniques to extract actionable data:

* Multi-Table Joins: Connecting patients, appointments, doctors, and billing.

* CTEs & Window Functions: Used to calculate Patient LTV and rank patients by their total contribution to revenue.

* Conditional Aggregates: Created a "Doctor Workload Efficiency" metric by calculating completion vs. no-show rates per doctor.

* Date Part Extraction: Monthly trend analysis for both revenue and appointment volume.
  

├── Data/     Cleaned datasets (CSV/Excel)

├── SQL_Scripts/

│   └── Health_Care_Analysis.sql   # Full database schema and queries

├── PowerBI_Dashboard/

│   └── Healthcare_Analysis.pbix   # Interactive Power BI file

└── Screenshots/            # Dashboard previews



📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

Author 

Anmol Verma
