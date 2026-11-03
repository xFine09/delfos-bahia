#!/usr/bin/env bash
# =====================================================================
# 07-postgres-odbc.sh — PostgreSQL, esquema hr vacío y DSN ODBC para DG4ODBC
# Ejecutar DENTRO DE LA VM como sercal, desde la raíz del repo.
# Antes: cambiar 'CambiaEstaClave1' en sql/postgres/00-crear-bd.sql.
# =====================================================================
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

# 1. Paquetes: servidor, driver ODBC de PostgreSQL y unixODBC (con libodbc.so)
sudo apt install -y postgresql odbc-postgresql unixodbc unixodbc-dev
psql --version
ls -l /usr/lib/x86_64-linux-gnu/libodbc.so*

# 2. Usuario migra, base rrhh y esquema hr; después las tablas (sin claves ajenas)
sudo -u postgres psql -v ON_ERROR_STOP=1 -f "$REPO/sql/postgres/00-crear-bd.sql"
echo ">>> Contraseña de migra:"
psql -h localhost -U migra -d rrhh -v ON_ERROR_STOP=1 -f "$REPO/sql/postgres/01-tablas-hr.sql"

# 3. DSN del sistema (editar la contraseña después: sudo nano /etc/odbc.ini)
grep -A3 "PostgreSQL Unicode" /etc/odbcinst.ini
grep -q "^\[PG_RRHH\]" /etc/odbc.ini 2>/dev/null || \
  sudo tee -a /etc/odbc.ini < "$REPO/scripts/odbc.ini.example" >/dev/null
sudo chmod 644 /etc/odbc.ini
echo ">>> Revisa la contraseña en /etc/odbc.ini y prueba:  isql -v PG_RRHH"
echo ">>> Dentro de isql:  SELECT current_schema;   (debe devolver hr)"
