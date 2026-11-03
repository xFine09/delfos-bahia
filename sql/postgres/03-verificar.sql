-- 03-verificar.sql — Recuento de filas en PostgreSQL tras la migración
-- Ejecutar como: psql -h localhost -U migra -d rrhh -f 03-verificar.sql
-- Esperado: 5, 25, 23, 19, 27, 107, 10
SET search_path = hr;
SELECT 'regions' AS tabla, count(*) FROM regions
UNION ALL SELECT 'countries',   count(*) FROM countries
UNION ALL SELECT 'locations',   count(*) FROM locations
UNION ALL SELECT 'jobs',        count(*) FROM jobs
UNION ALL SELECT 'departments', count(*) FROM departments
UNION ALL SELECT 'employees',   count(*) FROM employees
UNION ALL SELECT 'job_history', count(*) FROM job_history;
SELECT first_name, last_name, hire_date, salary FROM employees ORDER BY employee_id LIMIT 5;
