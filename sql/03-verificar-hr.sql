-- 03-verificar-hr.sql — Comprueba el esquema HR en BAHIAPDB
-- Ejecutar como: sqlplus hr@//delfos.inf:1521/bahiapdb.inf @03-verificar-hr.sql
-- Esperado: 7 tablas; 107 empleados
SET LINESIZE 120 PAGESIZE 100
SHOW USER
SELECT table_name FROM user_tables ORDER BY 1;
SELECT COUNT(*) AS empleados FROM employees;
SELECT first_name, last_name FROM employees WHERE ROWNUM <= 5;
EXIT
