select *
from (
    select
        dept_name, first_name, last_name, salary,
        dense_rank() over (partition by dept_name order by salary desc) as rang_salaire
    from {{ ref('mart_current_employee_stats') }}
) ranked
where rang_salaire <= 3