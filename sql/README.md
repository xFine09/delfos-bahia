# SQL

| Fichero | Ejecutar como | Uso |
|---------|---------------|-----|
| `01-abrir-pdb.sql` | `sqlplus / as sysdba` | Abre `BAHIAPDB` y guarda su estado |
| `02-verificar-bahia.sql` | `sqlplus / as sysdba` | BAHIA.INF, AL32UTF8, 8192, XE OPEN, PDB |
| `03-verificar-hr.sql` | `sqlplus hr@//delfos.inf:1521/bahiapdb.inf` | Tablas y filas de HR |
| `04-instalar-hr.sql` | `sqlplus system@//delfos.inf:1521/bahiapdb.inf` | Comprueba la PDB y lanza `hr_install.sql` |
