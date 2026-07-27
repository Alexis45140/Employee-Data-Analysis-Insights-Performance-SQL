select emp_no, title, from_date, to_date
from {{ source('hr', 'titles') }}