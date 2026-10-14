# Scripts de creación de BAHIA.inf

Scripts generados por DBCA con la opción de generar los ficheros de comandos de
creación, tal como pide el enunciado. Se generaron en modo silencioso con:

```bash
dbca -silent -generateScripts \
  -templateName XE_Database.dbc \
  -gdbName BAHIA.inf -sid XE \
  -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 \
  -createAsContainerDatabase true -numberOfPDBs 1 -pdbName BAHIAPDB \
  -datafileDestination /opt/oracle/oradata -storageType FS \
  -memoryMgmtType AUTO_SGA -totalMemory 1536 \
  -emConfiguration NONE \
  -scriptDest /opt/oracle/admin/BAHIA/scripts
```

El comando termina con `[FATAL] java.lang.NullPointerException`, pero los
scripts se generan completos (cabezazo 12 del log). Origen en el servidor:
`/opt/oracle/admin/BAHIA/scripts`.

## Parámetros de la base de datos

| Parámetro | Valor | Dónde se ve |
|-----------|-------|-------------|
| Nombre global | `BAHIA.inf` | `init.ora`: `db_name="BAHIA"`, `db_domain="inf"` |
| SID | `XE` | `XE.sh`, `XE.sql` |
| Juego de caracteres | `AL32UTF8` | `plug_PDBSeed.sql` |
| Tamaño de bloque | 8 KB | `init.ora`: `db_block_size=8192` |
| Arquitectura | CDB con la PDB `BAHIAPDB` | `plug_BAHIAPDB.sql` |

## Ficheros

| Fichero | Función |
|---------|---------|
| `XE.sh` | Script principal: crea los directorios y lanza `XE.sql` |
| `XE.sql` | Pide las contraseñas de SYS y SYSTEM y encadena el resto de scripts |
| `init.ora` | Parámetros de inicialización de la instancia |
| `initXETemp.ora`, `initXETempOMF.ora` | Parámetros temporales usados durante la clonación |
| `CloneRmanRestore.sql` | Arranca la instancia y restaura la plantilla con RMAN |
| `rmanRestoreDatafiles.sql` | Restaura los ficheros de datos de la plantilla *seed* |
| `cloneDBCreation.sql` | Crea la CDB a partir de la plantilla y renombra la base a BAHIA |
| `plug_PDBSeed.sql` | Conecta `PDB$SEED` y le aplica el juego de caracteres |
| `rmanPDBRestoreDatafiles.sql`, `rmanPDBCleanUpDatafiles.sql` | Restauran y limpian los ficheros de la PDB semilla |
| `PDBCreation.sql` | Lanza la creación de la PDB |
| `plug_BAHIAPDB.sql` | Crea la PDB `BAHIAPDB` |
| `postScripts.sql` | Componentes adicionales (Oracle Text, Multimedia...) |
| `lockAccount.sql` | Bloquea las cuentas internas no utilizadas |
| `postDBCreation.sql` | Recompila objetos inválidos y finaliza la configuración |

No se incluye `tempControl.ctl`: es un fichero de control binario temporal (~18 MB),
no un script.

## Seguridad

Los scripts no contienen contraseñas en claro: las piden al ejecutarse mediante
las variables de sustitución `&&sysPassword` y `&&systemPassword`.

## Cómo se copiaron al repositorio

Desde el anfitrión, en la raíz del repositorio (con fish, la ruta remota va entre
comillas para que el `*` no se expanda en local):

```bash
scp -r 'oracle@delfos.inf:/opt/oracle/admin/BAHIA/scripts/*' db-creation-scripts/
rm db-creation-scripts/tempControl.ctl
```
