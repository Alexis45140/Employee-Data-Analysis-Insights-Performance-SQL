select
    emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    case
        when hire_date > current_date then current_date
        else hire_date
    end as hire_date_clean
from {{ source('hr', 'employees') }}