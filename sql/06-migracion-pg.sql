-- 06-migracion-pg.sql — Puebla el esquema hr de PostgreSQL desde Oracle (HR en BAHIAPDB)
-- Ejecutar como HR:  sqlplus hr@//delfos.inf:1521/bahiapdb.inf @06-migracion-pg.sql
-- Orden según dependencias. Tablas y columnas de PostgreSQL en minúsculas y entre comillas.
SET ECHO ON FEEDBACK ON
WHENEVER SQLERROR EXIT ROLLBACK

INSERT INTO "regions"@pg_link ("region_id","region_name")
  SELECT region_id, region_name FROM regions;

INSERT INTO "countries"@pg_link ("country_id","country_name","region_id")
  SELECT country_id, country_name, region_id FROM countries;

INSERT INTO "locations"@pg_link ("location_id","street_address","postal_code","city","state_province","country_id")
  SELECT location_id, street_address, postal_code, city, state_province, country_id FROM locations;

INSERT INTO "jobs"@pg_link ("job_id","job_title","min_salary","max_salary")
  SELECT job_id, job_title, min_salary, max_salary FROM jobs;

INSERT INTO "departments"@pg_link ("department_id","department_name","manager_id","location_id")
  SELECT department_id, department_name, manager_id, location_id FROM departments;

INSERT INTO "employees"@pg_link ("employee_id","first_name","last_name","email","phone_number","hire_date","job_id","salary","commission_pct","manager_id","department_id")
  SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id FROM employees;

INSERT INTO "job_history"@pg_link ("employee_id","start_date","end_date","job_id","department_id")
  SELECT employee_id, start_date, end_date, job_id, department_id FROM job_history;

COMMIT;

-- Comparación Oracle / PostgreSQL
SET ECHO OFF
COLUMN tabla FORMAT A12
SELECT 'regions' tabla, (SELECT COUNT(*) FROM regions) oracle, (SELECT COUNT(*) FROM "regions"@pg_link) postgres FROM dual
UNION ALL SELECT 'countries',   (SELECT COUNT(*) FROM countries),   (SELECT COUNT(*) FROM "countries"@pg_link)   FROM dual
UNION ALL SELECT 'locations',   (SELECT COUNT(*) FROM locations),   (SELECT COUNT(*) FROM "locations"@pg_link)   FROM dual
UNION ALL SELECT 'jobs',        (SELECT COUNT(*) FROM jobs),        (SELECT COUNT(*) FROM "jobs"@pg_link)        FROM dual
UNION ALL SELECT 'departments', (SELECT COUNT(*) FROM departments), (SELECT COUNT(*) FROM "departments"@pg_link) FROM dual
UNION ALL SELECT 'employees',   (SELECT COUNT(*) FROM employees),   (SELECT COUNT(*) FROM "employees"@pg_link)   FROM dual
UNION ALL SELECT 'job_history', (SELECT COUNT(*) FROM job_history), (SELECT COUNT(*) FROM "job_history"@pg_link) FROM dual;
