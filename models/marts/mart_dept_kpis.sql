select
    dept_name as departement,
    count(emp_no) as nombre_employes,
    round(avg(salary), 0) as salaire_moyen,
    sum(salary) as masse_salariale_totale
from {{ ref('mart_current_employee_stats') }}
group by dept_name
order by salaire_moyen desc