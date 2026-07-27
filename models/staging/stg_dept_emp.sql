select emp_no, dept_no, from_date, to_date
from {{ source('hr', 'dept_emp') }}