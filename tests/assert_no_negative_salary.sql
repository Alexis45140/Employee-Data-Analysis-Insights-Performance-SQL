select * from {{ ref('mart_current_employee_stats') }}
where salary <= 0