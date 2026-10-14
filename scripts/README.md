# Scripts

Comandos del despliegue, en orden de ejecución y con las correcciones de los
cabezazos ya aplicadas (el número de cabezazo se cita en los comentarios).

| Script | Dónde / usuario | Qué hace |
|--------|-----------------|----------|
| `00a-anfitrion-cachyos.sh` | Anfitrión CachyOS | Qemu/KVM, libvirt, `LIBVIRT_DEFAULT_URI`, red `default`, ufw |
| `00b-anfitrion-debian.sh` | Anfitrión Debian | Qemu/KVM, libvirt, `LIBVIRT_DEFAULT_URI`, red `default` |
| `00c-bridge-nmcli.sh` | Anfitrión (cable) | Crea y activa el puente `br0` |
| `00d-crear-vm.sh` | Anfitrión | Verifica la ISO y crea la VM `delfos` |
| `01-preparar-ubuntu.sh` | VM, `sercal` | IP fija, `delfos.inf`, swap, ufw, usuario `oracle`, OFA, sysctl, límites, entorno |
| `02-ampliar-disco-anfitrion.sh` | Anfitrión | `qemu-img resize +30G` |
| `02-instalar-xe.sh` | VM, `sercal` | Amplía LVM, `alien` con `TMPDIR`, `dpkg -i` de Oracle XE 21c |
| `03-dbca-bahia.sh` | VM, `oracle` | Listener, scripts de DBCA, creación de BAHIA.inf, PDB abierta |
| `04-esquemas-ejemplo.sh` | VM, `oracle` | Esquema HR en `BAHIAPDB` |
| `05-arranque-automatico.sh` | VM, `sercal` | `/etc/oratab` y servicio `oracle-xe` |
| `vm-snapshot.sh` | Anfitrión | Apaga, crea instantánea y arranca |

Orden completo:
`00a/00b → 00c → 00d → 01 → snapshot s1 → 02-ampliar-disco-anfitrion → 02-instalar-xe → snapshot s2-xe-instalado → (sudo root.sh si hace falta) → 03 → snapshot s2-bahia-creada → 04 → 05 → reboot → snapshot s2-bahia-completa`.

Los scripts usan los ficheros de `config/` y `sql/`, así que se ejecutan desde una
copia del repositorio. Ninguno guarda contraseñas: DBCA, `passwd` y `hr_install.sql`
las piden por teclado.
