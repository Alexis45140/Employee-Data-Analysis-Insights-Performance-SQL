select
    first_name, last_name, dept_name, salary,
    round(avg(salary) over (partition by dept_name), 0) as avg_dept_salary,
    salary - round(avg(salary) over (partition by dept_name), 0) as difference_vs_avg
from {{ ref('mart_current_employee_stats') }}
order by difference_vs_avg desc
limit 20