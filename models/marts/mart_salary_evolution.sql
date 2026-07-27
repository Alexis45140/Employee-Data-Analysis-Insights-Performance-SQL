with sample_employees as (
    select emp_no
    from {{ ref('mart_current_employee_stats') }}
    limit 100
)

select
    s.emp_no,
    s.salary as current_salary,
    lag(s.salary) over (partition by s.emp_no order by s.from_date) as previous_salary,
    s.salary - lag(s.salary) over (partition by s.emp_no order by s.from_date) as increase_amount
from {{ ref('stg_salaries') }} s
join sample_employees se on s.emp_no = se.emp_no
order by s.emp_no, s.from_date