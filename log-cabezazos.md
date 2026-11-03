# Log de cabezazos

Problemas encontrados durante el proyecto y cómo se resolvieron.
La versión detallada, con capturas, está en el tutorial (`tutorial/latex/`).

| Nº | Fecha | Fase | Problema | Causa | Solución |
|----|-------|------|----------|-------|----------|
| 1 | 06/10/2026 | VM | `virsh shutdown delfos`: «error: incorrecto al obtener dominio». | La VM está en `qemu:///system` y `virsh` sin sudo usa `qemu:///session`. | `virsh -c qemu:///system ...` o `export LIBVIRT_DEFAULT_URI="qemu:///system"`. |
| 2 | 06/10/2026 | VM / red | `virt-install` falla: «No se puede obtener MTU del interfaz en 'br0': No existe el dispositivo». | El bridge `br0` no existía; tras crearlo con `nmcli con add` estaba definido pero no activado. | `nmcli con down "Conexión cableada 1"; nmcli con up br0-slave; nmcli con up br0` y desactivar el autoconnect de la conexión antigua. Solo con cable. |
| 3 | 06/10/2026 | Ubuntu | El primer `netplan try` deja la VM sin red y se revierte. | Se copió una configuración de ejemplo (`192.168.1.50/24`, gateway `192.168.1.1`) de otra red. | Usar los valores reales: `192.168.3.133/24` y gateway `192.168.3.1`. |
| 4 | 06/10/2026 | OFA | No existe `oracle-database-preinstall` para Ubuntu. | Oracle solo lo publica para Oracle Linux / RHEL. | Crear a mano `99-oracle.conf` (sysctl), `limits.d/oracle.conf`, usuario, grupos y directorios OFA. |
| 5 | 13/10/2026 | Instalación XE | `alien` aborta con «No space left on device». | Necesita ~20 GB temporales y el LV raíz tenía 19 GB (otros 19 GB sin asignar en el VG). | `lvextend -r -l +100%FREE`; además `qemu-img resize +30G`, `growpart`, `pvresize`, `lvextend` → 67 GB. |
| 6 | 13/10/2026 | Instalación XE | «zstd write error: No space left on device» con 55 GB libres; `.deb` de 521 KB. | `dpkg-deb` comprime en `/tmp`, que es un tmpfs en RAM de 1,7 GB. | `sudo env TMPDIR=/home/sercal/tmp-alien alien --scripts -d ...`. Los errores de `dpkg-shlibdeps` se ignoran. |
| 7 | 13/10/2026 | Instalación XE | El preinst falla con «awk: command not found». | `ln -sf /usr/bin/awk /bin/awk` con usrmerge creó el enlace circular `/usr/bin/awk -> /usr/bin/awk`. | `sudo rm /usr/bin/awk` y `sudo apt install --reinstall mawk`. No crear enlaces para awk. |
| 8 | 13/10/2026 | Instalación XE | «ORACLE_BASE directory (/opt/oracle) is not owned by oracle user». | El preinst comprueba la propiedad antes de desempaquetar. | `chown -R oracle:oinstall /opt/oracle /opt/oraInventory` **antes** de instalar (nunca después). |
| 9 | 13/10/2026 | DBCA | `dbca`: «DISPLAY not set». | Sesión `sudo su - oracle` sin reenvío X11; al pegar un bloque, lo que va tras `sudo su` se pierde. | `ssh -Y oracle@delfos.inf` o `xauth add`, ejecutando las órdenes de una en una. |
| 10 | 13/10/2026 | DBCA | «Invalid MIT-MAGIC-COOKIE-1 key» y `NoClassDefFoundError ... XToolkit`. | El escritorio del anfitrión (Wayland) no da cookie X11 válida («No xauth data; using fake authentication data»). | DBCA en modo silencioso (`-silent`). |
| 11 | 13/10/2026 | DBCA | `[DBT-12513]` El esquema de muestra no está soportado. | DBCA 21c ya no incluye los esquemas de ejemplo. | Crear sin `-sampleSchema` e instalarlos desde `oracle-samples/db-sample-schemas`. |
| 12 | 13/10/2026 | DBCA | `-generateScripts` acaba con `java.lang.NullPointerException`. | Fallo de DBCA al terminar; el progreso es simulado y no crea nada. | Ninguna: los 17 scripts se generan completos. |
| 13 | 13/10/2026 | DBCA | `[DBT-10011]` propiedad/permisos de `oradism` (`PRVG-11960`, `PRVG-2031`). | Un `chown -R` posterior a la instalación quitó a root la propiedad y el SUID de `oradism`. | `sudo $ORACLE_HOME/root.sh`. No usar `chown -R` sobre `/opt/oracle` tras instalar. |
| 14 | 13/10/2026 | DBCA | Aviso `[DBT-06208]` para SYS, SYSTEM y PDBADMIN. | Contraseñas cortas o prohibidas. | Contraseñas de 8+ caracteres con mayúsculas, minúsculas y dígitos, fuera del repo. |
| 15 | 13/10/2026 | BAHIA | Tras reiniciar, `BAHIAPDB` queda en `MOUNTED`. | Las PDB no se abren solas con la CDB. | `ALTER PLUGGABLE DATABASE BAHIAPDB OPEN;` y `... SAVE STATE;`. |
| 16 | 13/10/2026 | Esquemas | `hr_install.sql`: `ORA-65096` nombre de usuario o rol común no válido. | Se ejecutó en `CDB$ROOT` (solo admite usuarios `C##`). | Conectar a `//delfos.inf:1521/bahiapdb.inf` y comprobar `SHOW CON_NAME`. |
| 17 | 13/10/2026 | Esquemas | `ORA-01017` al conectar como SYSTEM. | Contraseña mal tecleada. | Reintroducir credenciales. |
| 18 | 13/10/2026 | Arranque | «I'm sorry oracle. I'm afraid I can't do that» con `sudo`. | `oracle` no tiene (ni debe tener) sudo. | Tareas de sistema con `sercal` (`su - sercal`). |
| 19 | 20/10/2026 | Cortafuegos | `ufw status` muestra `inactive` tras añadir la regla del 1521. | El cortafuegos no quedó activado en la semana 1. | `ufw allow OpenSSH`, `ufw allow 1521/tcp` y `ufw enable`. |
| 20 | 20/10/2026 | Acceso remoto | `orapwXE` no existe en `$ORACLE_HOME/dbs`. | Oracle 21c usa un ORACLE_HOME de solo lectura: los ficheros de instancia van en `$ORACLE_BASE/dbs`. | `orabaseconfig` → `/opt/oracle/dbs/orapwXE`. |
| 21 | 28/10/2026 | Cliente | `sqlplus -v` en Debian: no encuentra `libaio.so.1`. | Debian 13 la distribuye como `libaio.so.1t64`. | `ln -s libaio.so.1t64 libaio.so.1` y `ldconfig`. |
| 22 | 03/11/2026 | Traslado VM | La IP fija no se aplica en KVM; la VM toma `192.168.3.212` por DHCP. | Netplan configuraba `enp0s3` (VirtualBox); en KVM la interfaz es `enp1s0`. | Renombrar la interfaz en `00-installer-config.yaml` y `netplan try`. |
| 23 | 03/11/2026 | Traslado VM | `ORA-12543`: host de destino no accesible. | `/etc/hosts` sin `delfos.inf`: se resolvía a la IPv6 `fe80::`. | Añadir `192.168.3.133 delfos.inf delfos` y quitar `127.0.1.1 delfos`. |
| 24 | 03/11/2026 | Listener | La BD no se registra; solo aparece `PGSQL`. | `local_listener` vacío y resolución antigua del nombre. | `local_listener` con la IP explícita y `ALTER SYSTEM REGISTER`. |
| 25 | 03/11/2026 | DB link | `ORA-01017` al conectar como `SYSTEM`. | Contraseña distinta de la de DBCA. | `sqlplus / as sysdba` + `ALTER SESSION SET CONTAINER = BAHIAPDB`. |
| 26 | 03/11/2026 | DG4ODBC | `ORA-28500` con `IM002`: DSN no encontrado, aunque `isql` funciona. | Modo Unicode del gateway (`AL32UTF8` + `HS_NLS_NCHAR = UCS2`). | `HS_LANGUAGE = AMERICAN_AMERICA.WE8ISO8859P15`, sin `HS_NLS_NCHAR`. |
| 27 | 03/11/2026 | Migración | `ORA-02025` en `INSERT ... SELECT` hacia PostgreSQL. | Los servicios heterogéneos no admiten DML que mezcle tablas locales y remotas. | Bucle PL/SQL que inserta fila a fila con `VALUES`. |
