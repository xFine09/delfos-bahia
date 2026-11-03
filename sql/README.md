# SQL

| Fichero | Ejecutar como | Uso |
|---------|---------------|-----|
| `01-abrir-pdb.sql` | `sqlplus / as sysdba` | Abre `BAHIAPDB` y guarda su estado |
| `02-verificar-bahia.sql` | `sqlplus / as sysdba` | BAHIA.INF, AL32UTF8, 8192, XE OPEN, PDB |
| `03-verificar-hr.sql` | `sqlplus hr@//delfos.inf:1521/bahiapdb.inf` | Tablas y filas de HR |
| `04-instalar-hr.sql` | `sqlplus system@//delfos.inf:1521/bahiapdb.inf` | Comprueba la PDB y lanza `hr_install.sql` |
| `05-dblink-pg.sql` | `sqlplus hr@//delfos.inf:1521/bahiapdb.inf` | Crea el DB link `pg_link` a PostgreSQL |
| `06-migracion-pg.sql` | `sqlplus hr@//delfos.inf:1521/bahiapdb.inf` | Copia las 7 tablas de HR a PostgreSQL y compara recuentos |
| `postgres/00-crear-bd.sql` | `sudo -u postgres psql` | Usuario `migra`, base `rrhh`, esquema `hr` |
| `postgres/01-tablas-hr.sql` | `psql -h localhost -U migra -d rrhh` | Tablas de HR sin claves ajenas |
| `postgres/02-claves-ajenas.sql` | `psql -h localhost -U migra -d rrhh` | Claves ajenas tras la carga |
| `postgres/03-verificar.sql` | `psql -h localhost -U migra -d rrhh` | Recuentos y muestra de datos |
