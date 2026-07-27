select emp_no, salary, from_date, to_date
from {{ source('hr', 'salaries') }}