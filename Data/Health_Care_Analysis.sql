-- Create Hospital managment dataset DATABASE
CREATE DATABASE Hospital_Management_Dataset 

-- Create patients table 
CREATE TABLE patients (
patient_id VARCHAR(6) PRIMARY KEY Not Null,
first_name VARCHAR(20),
last_name VARCHAR(20),
gender CHAR(5),
date_of_birth DATE,
contact_number VARCHAR(15),
address VARCHAR(40),
registration_date DATE,
insurance_provider VARCHAR(50),
insurance_number VARCHAR(45),
email VARCHAR(50) NOT NULL
)


-- Import Data into patients TABLE
SELECT *
FROM patients

-- CREATE doctors TABLE
CREATE TABLE doctors (
doctor_id VARCHAR(5) PRIMARY key Not Null,	
first_name VARCHAR(15),
last_name VARCHAR(15),
specialization VARCHAR(20),
phone_number VARCHAR(15),
years_experience CHAR(2),
hospital_branch VARCHAR(30),
email VARCHAR(40) NOT NULL
)

-- Import Data into doctors TABLE
SELECT *
FROM doctors

-- CREATE appointments TABLE
CREATE TABLE appointments (
appointment_id VARCHAR(5) PRIMARY key, 
patient_id VARCHAR(5),
doctor_id VARCHAR(5),
appointment_date date,
reason_for_visit VARCHAR(40),
status VARCHAR(25),
FOREIGN key (patient_id) REFERENCES patients (patient_id),
FOREIGN key (doctor_id) REFERENCES doctors (doctor_id)
)


-- Import Data into appointments TABLE
SELECT *
from appointments

-- create treatments TABLE
CREATE TABLE treatments(
treatment_id VARCHAR(5) PRIMARY key,
appointment_id VARCHAR(5),
treatment_type VARCHAR(30),
description VARCHAR(50),
cost FLOAT,
treatment_date DATE,
foreign key (appointment_id) REFERENCES  appointments (appointment_id) 
)

-- Import Data into treatments TABLE
SELECT *
from treatments 

-- create table billing
CREATE TABLE billing(
bill_id VARCHAR(5) PRIMARY key,
patient_id VARCHAR(5),
treatment_id VARCHAR(5),
bill_date DATE,
amount FLOAT,
payment_method VARCHAR(15),
payment_status VARCHAR(15),
foreign key (patient_id) REFERENCES patients (patient_id),
foreign key (treatment_id) REFERENCES treatments (treatment_id)
)

-- IMPORT data to billing TABLE
SELECT * 
from billing

-- I have cleaned Data using excel
-- Let's begien our Basic LEVEL Analysis

-- Identify the patients by gender
SELECT gender , count(*) 
FROM patients 
GROUP BY gender

-- Count of appointments by status
SELECT status, count(*)
from appointments
group by status

-- Total revenue generated
SELECT round(sum(amount)) AS Total_Revenue
from billing

-- Top 5 most common treatment types

SELECT treatment_type , count(*) AS Count_of_Treatment_type
from treatments
group by treatment_type
ORDER By Count_of_Treatment_type DESC
limit 5 

-- Monthly appointments count
SELECT 
      Extract(Month From appointment_date) AS Month,
      TO_CHAR (appointment_date, 'Mon-YYYY') AS Year,
	  Count(*)
from appointments
Group By Month , Year
order by Month

-- Let's Begin our Medium Level Analysis
-- let's Calculate revenue by MONTH
 SELECT 
      Extract(Month From bill_date) AS Month,
      TO_CHAR (bill_date, 'Mon-YYYY') AS Year,
	  Round (SUM(amount:: Numeric),2)
from billing
Group By Month , Year
order by Month

-- Calculate Appointments_per_Doctor by Hospital branch
SELECT hospital_branch , Round (count(appointment_id)::"numeric" / count( Distinct (d.doctor_id)),2) AS Appointments_per_Doctor
FROM appointments as a 
INNER JOIN doctors as d 
on a.doctor_id = d.doctor_id
GROUP by hospital_branch

-- Revenue by specilization 
SELECT d.specialization , round (Sum(b.amount::"numeric"),2) as  Revenue
from doctors as d
JOIN appointments as a
on d.doctor_id = a.doctor_id
JOIN billing as b 
on a.patient_id = b.patient_id
GROUP by d.specialization

-- Insurance Performance
SELECT insurance_provider , count(*) AS No_of_failed_or_pending_payments
from patients as p
join billing as b
on p.patient_id = b.patient_id 
where (payment_status = 'Pending' or payment_status = 'Failed') And (Payment_method = 'Insurance')
group by insurance_provider 
ORDER by No_of_failed_or_pending_payments DESC

-- Failed or Pending revenue by MONTH
 SELECT 
      Extract(Month From bill_date) AS Month,
      TO_CHAR (bill_date, 'Mon-YYYY') AS Year,
	  Round (SUM(amount:: Numeric),2)
from billing
WHERE payment_status = 'pending' or payment_status = 'Failed'
Group By Month , Year
order by Month

-- Let's Us begin Advance Analysis
-- Calculate this Patient Lifetime Value (LTV)
WITH patient_revenue AS (
    SELECT
        p.patient_id,
        Concat(first_name,' ', last_name) AS full_name,
        Round (SUM(b.amount::"numeric"),2) AS patient_ltv,
        COUNT(distinct (a.appointment_id)) AS total_visits
    FROM patients p
    JOIN appointments a
        ON p.patient_id = a.patient_id
    JOIN billing b
        ON a.patient_id = b.patient_id
    GROUP BY p.patient_id, full_name
)
SELECT
    patient_id,
    full_name,
    total_visits,
    patient_ltv,
    RANK() OVER (ORDER BY patient_ltv DESC) AS revenue_rank
FROM patient_revenue
ORDER BY patient_ltv DESC;

-- Doctor Experience vs Cost
SELECT d.doctor_id , concat(first_name,' ', last_name) AS full_name , years_experience, specialization, round (Sum(cost::"numeric"),2) as total_revenue
FROM doctors as d
JOIN appointments as a
on d.doctor_id = a.doctor_id
JOIN treatments as t
ON a.appointment_id = t.appointment_id 
WHERE  years_experience::numeric > 20
GROUP by d.doctor_id, full_name, specialization
ORDER by years_experience DESC

-- Treatment-to-Billing Gap or revenue lekage
SELECT t.treatment_id , treatment_type , payment_method ,  b.payment_status 
FROM treatments as t 
left join billing as b
ON t.treatment_id = b.treatment_id
WHERE payment_status = 'Pending' or payment_status = 'Failed'
group by t.treatment_id , b.payment_status, payment_method, treatment_type

-- Doctor Cancellation & No-Show Analysis
WITH doctor_appointments_stats AS (
     SELECT 
	       doctor_id,
		   count(*) AS Total_appointments,
		   Sum(case when status = 'Completed' Then 1 else 0 end) as completed_count,
		   Sum(case when status = 'Scheduled' then 1 ELSE 0 end) as Scheduled_count,
	       Sum(case when status = 'No-show'   Then 1 else 0 end) as No_show_count,
		   Sum(case when status = 'Cancelled' Then 1 else 0 end) as cancelled_count
     FROM appointments
	 group by doctor_id
)
SELECT 
     da.doctor_id,
	 concat(d.first_name,' ', d.last_name) as full_name,
	 Total_appointments,
	 completed_count,
	 Scheduled_count,
	 No_show_count,
	 cancelled_count,
	 round(((completed_count::"numeric" / Total_appointments) *100 ),2) as completion_rate,
	 round(((scheduled_count::"numeric" / Total_appointments) *100 ),2) as scheduled_rate,
	 round(((no_show_count::"numeric" / Total_appointments) *100 ),2) as no_show_rate,
	 round(((cancelled_count::"numeric" / Total_appointments) *100 ),2) as completion_rate
from doctor_appointments_stats as da
join doctors as d 
on da.doctor_id = d.doctor_id
ORDER by Total_appointments desc













