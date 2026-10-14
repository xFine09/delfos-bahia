# Configuración

| Fichero | Destino en delfos.inf |
|---------|-----------------------|
| `00-installer-config.yaml` | `/etc/netplan/00-installer-config.yaml` (IP fija) |
| `hosts` | Línea para `/etc/hosts` de la VM y de los anfitriones |
| `99-oracle.conf` | `/etc/sysctl.d/99-oracle.conf` |
| `limits-oracle.conf` | `/etc/security/limits.d/oracle.conf` |
| `bash_profile-oracle` | Final de `/home/oracle/.bash_profile` |
| `listener.ora` | `$ORACLE_HOME/network/admin/listener.ora` |
| `oracle-xe.service` | `/etc/systemd/system/oracle-xe.service` |

No incluir contraseñas reales.
