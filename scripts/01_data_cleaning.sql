-- ==========================================
-- PROJET : Analyse RH - Nettoyage des Données
-- OBJECTIF : Standardiser les dates et vérifier l'intégrité
-- ==========================================

-- 1. Identification et gestion des dates "infinies" (9999-01-01)
-- Dans cette base, '9999-01-01' signifie que l'employé est toujours en poste.
-- On va créer une VUE pour ne pas modifier les données sources mais travailler proprement.
USE employees;
CREATE OR REPLACE VIEW v_employees_clean AS
SELECT 
    emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date,
    -- On remplace la date fictive par la date du jour pour les calculs d'ancienneté
    CASE 
        WHEN hire_date > CURRENT_DATE THEN CURRENT_DATE -- Sécurité si données futures
        ELSE hire_date 
    END as hire_date_clean
FROM employees;

-- 2. Vérification des doublons
-- On utilise une CTE pour isoler les doublons potentiels sur les salaires
WITH DuplicateSalaries AS (
    SELECT 
        emp_no, 
        salary, 
        from_date,
        ROW_NUMBER() OVER(PARTITION BY emp_no, from_date ORDER BY to_date DESC) as row_num
    FROM salaries
)
SELECT * FROM DuplicateSalaries 
WHERE row_num > 1; 
-- Si cette requête est vide, bravo : tes données de base sont uniques !

-- 3. Création d'une table de travail "Current_Status"
-- Pour éviter de refaire des JOINS complexes à chaque fois, on crée une table optimisée
-- avec les derniers salaires et départements de chaque employé.

DROP TABLE IF EXISTS current_employee_stats;

CREATE TABLE current_employee_stats AS
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    d.dept_name,
    s.salary,
    t.title,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_in_company
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE s.to_date = '9999-01-01' 
  AND de.to_date = '9999-01-01' 
  AND t.to_date = '9999-01-01';

-- 4. Audit de qualité : Vérifier s'il reste des valeurs NULL
SELECT 
    COUNT(*) - COUNT(emp_no) as missing_emp_id,
    COUNT(*) - COUNT(salary) as missing_salaries,
    COUNT(*) - COUNT(dept_name) as missing_depts
FROM current_employee_stats;
