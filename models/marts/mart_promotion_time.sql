select
    t.title as poste,
    round(avg(timestampdiff(year, e.hire_date_clean, t.from_date)), 1) as annees_moyennes_pour_promotion
from {{ ref('stg_employees') }} e
join {{ ref('stg_titles') }} t on e.emp_no = t.emp_no
where t.title like '%Senior%'
group by t.title