-- 00-crear-bd.sql — Usuario, base de datos y esquema destino en PostgreSQL
-- Ejecutar en delfos.inf como: sudo -u postgres psql -f 00-crear-bd.sql
-- CAMBIA la contraseña antes de ejecutarlo (y usa la misma en odbc.ini y en el DB link).
CREATE ROLE migra LOGIN PASSWORD 'CambiaEstaClave1';
CREATE DATABASE rrhh OWNER migra ENCODING 'UTF8' TEMPLATE template0;
\c rrhh
CREATE SCHEMA hr AUTHORIZATION migra;
ALTER ROLE migra IN DATABASE rrhh SET search_path = hr;
