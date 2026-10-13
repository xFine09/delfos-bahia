# Log de cabezazos

Problemas encontrados durante el proyecto y cómo se resolvieron.
La versión detallada, con capturas, está en el tutorial (`tutorial/latex/`).

| Nº | Fecha | Fase | Problema | Causa | Solución |
|----|-------|------|----------|-------|----------|
| 1 | 06/10/2026 | VM / red | `virt-install` falla: «No se puede obtener MTU del interfaz en 'br0': No existe el dispositivo». | El bridge `br0` no existía; tras crearlo con `nmcli con add` estaba definido pero no activado. | `nmcli con down "Conexión cableada 1"; nmcli con up br0-slave; nmcli con up br0` y desactivar el autoconnect de la conexión antigua. Solo con cable. |
| 2 | 06/10/2026 | VM | `virsh shutdown delfos`: «error: incorrecto al obtener dominio». | La VM está en `qemu:///system` y `virsh` sin sudo usa `qemu:///session`. | `virsh -c qemu:///system ...` o `export LIBVIRT_DEFAULT_URI="qemu:///system"`. |
| 3 | 06/10/2026 | OFA | No existe `oracle-database-preinstall` para Ubuntu. | Oracle solo lo publica para Oracle Linux / RHEL. | Crear a mano `99-oracle.conf` (sysctl), `limits.d/oracle.conf`, usuario, grupos y directorios OFA. |
| 4 | 13/10/2026 | Instalación XE | `alien` aborta con «No space left on device». | Necesita ~20 GB temporales y el LV raíz tenía 19 GB (otros 19 GB sin asignar en el VG). | `lvextend -r -l +100%FREE`; además `qemu-img resize +30G`, `growpart`, `pvresize`, `lvextend` → 67 GB. |
| 5 | 13/10/2026 | Instalación XE | «zstd write error: No space left on device» con 55 GB libres; `.deb` de 521 KB. | `dpkg-deb` comprime en `/tmp`, que es un tmpfs en RAM de 1,7 GB. | `sudo env TMPDIR=/home/sercal/tmp-alien alien --scripts -d ...`. Los errores de `dpkg-shlibdeps` se ignoran. |
| 6 | 13/10/2026 | Instalación XE | El preinst falla con «awk: command not found». | `ln -sf /usr/bin/awk /bin/awk` con usrmerge creó el enlace circular `/usr/bin/awk -> /usr/bin/awk`. | `sudo rm /usr/bin/awk` y `sudo apt install --reinstall mawk`. No crear enlaces para awk. |
| 7 | 13/10/2026 | Instalación XE | «ORACLE_BASE directory (/opt/oracle) is not owned by oracle user». | El preinst comprueba la propiedad antes de desempaquetar. | `chown -R oracle:oinstall /opt/oracle /opt/oraInventory` **antes** de instalar (nunca después). |
| 8 | 13/10/2026 | DBCA | `dbca`: «DISPLAY not set». | Sesión `sudo su - oracle` sin reenvío X11; al pegar un bloque, lo que va tras `sudo su` se pierde. | `ssh -Y oracle@delfos.inf` o `xauth add`, ejecutando las órdenes de una en una. |
| 9 | 13/10/2026 | DBCA | «Invalid MIT-MAGIC-COOKIE-1 key» y `NoClassDefFoundError ... XToolkit`. | El escritorio del anfitrión (Wayland) no da cookie X11 válida («No xauth data; using fake authentication data»). | DBCA en modo silencioso (`-silent`). |
| 10 | 13/10/2026 | DBCA | `[DBT-12513]` El esquema de muestra no está soportado. | DBCA 21c ya no incluye los esquemas de ejemplo. | Crear sin `-sampleSchema` e instalarlos desde `oracle-samples/db-sample-schemas`. |
| 11 | 13/10/2026 | DBCA | `-generateScripts` acaba con `java.lang.NullPointerException`. | Fallo de DBCA al terminar; el progreso es simulado y no crea nada. | Ninguna: los 17 scripts se generan completos. |
| 12 | 13/10/2026 | DBCA | `[DBT-10011]` propiedad/permisos de `oradism` (`PRVG-11960`, `PRVG-2031`). | Un `chown -R` posterior a la instalación quitó a root la propiedad y el SUID de `oradism`. | `sudo $ORACLE_HOME/root.sh`. No usar `chown -R` sobre `/opt/oracle` tras instalar. |
| 13 | 13/10/2026 | DBCA | Aviso `[DBT-06208]` para SYS, SYSTEM y PDBADMIN. | Contraseñas cortas o prohibidas. | Contraseñas de 8+ caracteres con mayúsculas, minúsculas y dígitos, fuera del repo. |
| 14 | 13/10/2026 | BAHIA | Tras reiniciar, `BAHIAPDB` queda en `MOUNTED`. | Las PDB no se abren solas con la CDB. | `ALTER PLUGGABLE DATABASE BAHIAPDB OPEN;` y `... SAVE STATE;`. |
| 15 | 13/10/2026 | Esquemas | `hr_install.sql`: `ORA-65096` nombre de usuario o rol común no válido. | Se ejecutó en `CDB$ROOT` (solo admite usuarios `C##`). | Conectar a `//delfos.inf:1521/bahiapdb.inf` y comprobar `SHOW CON_NAME`. |
| 16 | 13/10/2026 | Esquemas | `ORA-01017` al conectar como SYSTEM. | Contraseña mal tecleada. | Reintroducir credenciales. |
| 17 | 13/10/2026 | Arranque | «I'm sorry oracle. I'm afraid I can't do that» con `sudo`. | `oracle` no tiene (ni debe tener) sudo. | Tareas de sistema con `sercal` (`su - sercal`). |
