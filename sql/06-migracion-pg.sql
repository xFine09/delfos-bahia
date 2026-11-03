-- 06-migracion-pg.sql — Puebla el esquema hr de PostgreSQL desde Oracle (HR en BAHIAPDB)
-- Ejecutar como HR:  sqlplus hr@//delfos.inf:1521/bahiapdb.inf @06-migracion-pg.sql
-- DG4ODBC no admite INSERT ... SELECT que mezcle tablas locales y remotas
-- (ORA-02025), así que se recorre cada tabla local y se inserta fila a fila.
-- Orden según dependencias. Tablas y columnas de PostgreSQL en minúsculas y entre comillas.
SET SERVEROUTPUT ON FEEDBACK ON
WHENEVER SQLERROR EXIT ROLLBACK

DECLARE
  n PLS_INTEGER;
BEGIN
  n := 0;
  FOR r IN (SELECT * FROM regions ORDER BY region_id) LOOP
    INSERT INTO "regions"@pg_link ("region_id","region_name")
    VALUES (r.region_id, r.region_name);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('regions:     ' || n);

  n := 0;
  FOR r IN (SELECT * FROM countries ORDER BY country_id) LOOP
    INSERT INTO "countries"@pg_link ("country_id","country_name","region_id")
    VALUES (r.country_id, r.country_name, r.region_id);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('countries:   ' || n);

  n := 0;
  FOR r IN (SELECT * FROM locations ORDER BY location_id) LOOP
    INSERT INTO "locations"@pg_link ("location_id","street_address","postal_code","city","state_province","country_id")
    VALUES (r.location_id, r.street_address, r.postal_code, r.city, r.state_province, r.country_id);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('locations:   ' || n);

  n := 0;
  FOR r IN (SELECT * FROM jobs ORDER BY job_id) LOOP
    INSERT INTO "jobs"@pg_link ("job_id","job_title","min_salary","max_salary")
    VALUES (r.job_id, r.job_title, r.min_salary, r.max_salary);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('jobs:        ' || n);

  n := 0;
  FOR r IN (SELECT * FROM departments ORDER BY department_id) LOOP
    INSERT INTO "departments"@pg_link ("department_id","department_name","manager_id","location_id")
    VALUES (r.department_id, r.department_name, r.manager_id, r.location_id);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('departments: ' || n);

  n := 0;
  FOR r IN (SELECT * FROM employees ORDER BY employee_id) LOOP
    INSERT INTO "employees"@pg_link ("employee_id","first_name","last_name","email","phone_number","hire_date","job_id","salary","commission_pct","manager_id","department_id")
    VALUES (r.employee_id, r.first_name, r.last_name, r.email, r.phone_number, r.hire_date, r.job_id, r.salary, r.commission_pct, r.manager_id, r.department_id);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('employees:   ' || n);

  n := 0;
  FOR r IN (SELECT * FROM job_history ORDER BY employee_id, start_date) LOOP
    INSERT INTO "job_history"@pg_link ("employee_id","start_date","end_date","job_id","department_id")
    VALUES (r.employee_id, r.start_date, r.end_date, r.job_id, r.department_id);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('job_history: ' || n);

  COMMIT;
END;
/

-- Comparación Oracle / PostgreSQL
COLUMN tabla FORMAT A12
SELECT 'regions' tabla, (SELECT COUNT(*) FROM regions) oracle, (SELECT COUNT(*) FROM "regions"@pg_link) postgres FROM dual
UNION ALL SELECT 'countries',   (SELECT COUNT(*) FROM countries),   (SELECT COUNT(*) FROM "countries"@pg_link)   FROM dual
UNION ALL SELECT 'locations',   (SELECT COUNT(*) FROM locations),   (SELECT COUNT(*) FROM "locations"@pg_link)   FROM dual
UNION ALL SELECT 'jobs',        (SELECT COUNT(*) FROM jobs),        (SELECT COUNT(*) FROM "jobs"@pg_link)        FROM dual
UNION ALL SELECT 'departments', (SELECT COUNT(*) FROM departments), (SELECT COUNT(*) FROM "departments"@pg_link) FROM dual
UNION ALL SELECT 'employees',   (SELECT COUNT(*) FROM employees),   (SELECT COUNT(*) FROM "employees"@pg_link)   FROM dual
UNION ALL SELECT 'job_history', (SELECT COUNT(*) FROM job_history), (SELECT COUNT(*) FROM "job_history"@pg_link) FROM dual;
