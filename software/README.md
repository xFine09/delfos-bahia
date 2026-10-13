# Software

Paquetes utilizados. No se versionan los binarios; se indican origen y hash.

| Paquete | Versión | Descarga |
|---------|:-------:|:--------:|
| Oracle Database XE (`oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm`) | 21c (21.3.0.0.0) | [Descargar](https://www.oracle.com/database/technologies/xe-downloads.html) |
| Oracle Preinstall (si aplica) | — | — |
| Ubuntu Server LTS (ISO) | 26.04.1 | [Descargar](https://ubuntu.com/download/server/thank-you?version=26.04.1&architecture=amd64&lts=true) |
| PostgreSQL | — | — |
| unixODBC / psqlODBC | — | — |

## Verificación SHA256

```text
ubuntu-26.04.1-live-server-amd64.iso
cc8a95cde20f6ced61a322420de00f10cc3c90ced545daa46cb9c1a117f1d927

oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm
f8357b432de33478549a76557e8c5220ec243710ed86115c65b0c2bc00a848db
```

Para comprobar el hash en Git Bash:

```bash
sha256sum ubuntu-26.04.1-live-server-amd64.iso
```