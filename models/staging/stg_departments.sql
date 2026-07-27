select dept_no, dept_name
from {{ source('hr', 'departments') }}