select first_name, last_name, dept_name, salary, years_in_company
from {{ ref('mart_current_employee_stats') }}
where years_in_company > 15 and salary > 80000
order by salary desc
limit 10