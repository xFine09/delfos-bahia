-- 02-claves-ajenas.sql — Claves ajenas de HR, una vez cargados los datos
-- Ejecutar como: psql -h localhost -U migra -d rrhh -f 02-claves-ajenas.sql
SET search_path = hr;
ALTER TABLE countries   ADD FOREIGN KEY (region_id)     REFERENCES regions;
ALTER TABLE locations   ADD FOREIGN KEY (country_id)    REFERENCES countries;
ALTER TABLE departments ADD FOREIGN KEY (location_id)   REFERENCES locations;
ALTER TABLE departments ADD FOREIGN KEY (manager_id)    REFERENCES employees;
ALTER TABLE employees   ADD FOREIGN KEY (job_id)        REFERENCES jobs;
ALTER TABLE employees   ADD FOREIGN KEY (department_id) REFERENCES departments;
ALTER TABLE employees   ADD FOREIGN KEY (manager_id)    REFERENCES employees;
ALTER TABLE job_history ADD FOREIGN KEY (employee_id)   REFERENCES employees;
ALTER TABLE job_history ADD FOREIGN KEY (job_id)        REFERENCES jobs;
ALTER TABLE job_history ADD FOREIGN KEY (department_id) REFERENCES departments;
