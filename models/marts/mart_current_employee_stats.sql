{{ config(
    materialized='table',
    post_hook="CREATE INDEX idx_lastname ON {{ this }} (last_name)"
) }}

with current_salary as (
    select * from {{ ref('stg_salaries') }} where to_date = '9999-01-01'
),
current_title as (
    select * from {{ ref('stg_titles') }} where to_date = '9999-01-01'
),
current_dept as (
    select * from {{ ref('stg_dept_emp') }} where to_date = '9999-01-01'
)

select
    e.emp_no,
    e.first_name,
    e.last_name,
    d.dept_name,
    s.salary,
    t.title,
    timestampdiff(year, e.hire_date_clean, current_date) as years_in_company
from {{ ref('stg_employees') }} e
join current_salary s on e.emp_no = s.emp_no
join current_dept cd on e.emp_no = cd.emp_no
join {{ ref('stg_departments') }} d on cd.dept_no = d.dept_no
join current_title t on e.emp_no = t.emp_no