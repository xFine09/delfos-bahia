-- 01-tablas-hr.sql — Tablas del esquema HR en PostgreSQL (sin claves ajenas)
-- Ejecutar como: psql -h localhost -U migra -d rrhh -f 01-tablas-hr.sql
-- Nombres en minúsculas (Oracle los referenciará entre comillas: "employees"@pg_link).
-- Las claves ajenas se crean DESPUÉS de cargar los datos (02-claves-ajenas.sql),
-- porque departments y employees se referencian entre sí.
SET search_path = hr;

CREATE TABLE regions (
  region_id      numeric       PRIMARY KEY,
  region_name    varchar(50)
);

CREATE TABLE countries (
  country_id     char(2)       PRIMARY KEY,
  country_name   varchar(60),
  region_id      numeric
);

CREATE TABLE locations (
  location_id    numeric(4)    PRIMARY KEY,
  street_address varchar(60),
  postal_code    varchar(20),
  city           varchar(40)   NOT NULL,
  state_province varchar(40),
  country_id     char(2)
);

CREATE TABLE jobs (
  job_id         varchar(10)   PRIMARY KEY,
  job_title      varchar(50)   NOT NULL,
  min_salary     numeric(6),
  max_salary     numeric(6)
);

CREATE TABLE departments (
  department_id   numeric(4)   PRIMARY KEY,
  department_name varchar(40)  NOT NULL,
  manager_id      numeric(6),
  location_id     numeric(4)
);

CREATE TABLE employees (
  employee_id    numeric(6)    PRIMARY KEY,
  first_name     varchar(30),
  last_name      varchar(30)   NOT NULL,
  email          varchar(30)   NOT NULL,
  phone_number   varchar(30),
  hire_date      date          NOT NULL,
  job_id         varchar(10)   NOT NULL,
  salary         numeric(8,2),
  commission_pct numeric(2,2),
  manager_id     numeric(6),
  department_id  numeric(4)
);

CREATE TABLE job_history (
  employee_id    numeric(6)    NOT NULL,
  start_date     date          NOT NULL,
  end_date       date          NOT NULL,
  job_id         varchar(10)   NOT NULL,
  department_id  numeric(4),
  PRIMARY KEY (employee_id, start_date)
);

\dt hr.*
