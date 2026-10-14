# delfos-bahia

Mini proyecto transversal de **Administración de Sistemas Gestores de Bases de Datos**
(2º ASIR, I.E.S. Fernando Aguilar Quignon, curso 2026/2027).

Despliegue de la máquina virtual **delfos.inf** (Ubuntu Server 26.04.1 LTS sobre
Qemu/KVM) con **Oracle Database 21c XE** siguiendo la arquitectura OFA, y creación de
la base de datos **BAHIA.inf** con los esquemas de ejemplo y los scripts de creación
generados por DBCA. Como ampliación, se exporta un esquema a **PostgreSQL** mediante un
*database link* con servicios heterogéneos (DG4ODBC).

## Datos clave

| Elemento | Valor |
|----------|-------|
| Máquina virtual | `delfos.inf` · 192.168.3.133 · 4 GB RAM, 2 vCPU, 70 GB |
| Sistema operativo | Ubuntu Server 26.04.1 LTS |
| Red | Puente `br0` sobre la red local |
| SGBD | Oracle Database 21c Express Edition (21.3.0.0.0) |
| `ORACLE_HOME` | `/opt/oracle/product/21c/dbhomeXE` |
| Base de datos | `BAHIA.inf` · SID `XE` · `AL32UTF8` · bloque 8 KB |
| Contenedor | CDB con la PDB `BAHIAPDB` (servicio `bahiapdb.inf`) |
| Esquema de ejemplo | `HR` en `BAHIAPDB` |
| Ampliación | PostgreSQL + DB link vía DG4ODBC |

## Estado

| Fase | Contenido | Estado |
|------|-----------|:------:|
| 1 | VM, Ubuntu Server, IP fija y arquitectura OFA | ✅ |
| 2 | Oracle XE 21c, BAHIA.inf con DBCA, esquema HR, arranque automático | ✅ |
| 3 | Acceso remoto (listener, cortafuegos, conexión como administrador) | ⏳ |
| 4 | PostgreSQL y DB link Oracle → PostgreSQL (DG4ODBC) | ⏳ |
| 5 | Tutorial final, vídeo y demostración | ⏳ |

## Estructura del repositorio

```
delfos-bahia/
├── tutorial/latex/       Tutorial en LaTeX (main.tex + un fichero por semana)
│   ├── main.tex
│   ├── Semana1.tex, Semana2.tex
│   ├── Cabezazos.tex     Anexo con el log de cabezazos
│   └── Images/SemanaN/   Capturas de cada semana
├── scripts/              Scripts de despliegue, en orden de ejecución
├── config/               netplan, sysctl, límites, listener.ora, servicio systemd...
├── sql/                  Apertura de la PDB, verificaciones e instalación de HR
├── db-creation-scripts/  Scripts de creación generados por DBCA
├── software/             Enlaces y hashes del software utilizado
└── log-cabezazos.md      Problemas encontrados y sus soluciones
```

## Cómo reproducir el despliegue

1. Descargar el software indicado en [`software/README.md`](software/README.md) y
   comprobar sus hashes. Los paquetes de Oracle no se versionan.
2. Ejecutar los scripts de [`scripts/`](scripts/README.md) en orden. Cada uno indica
   si va en el anfitrión o en la VM y con qué usuario. Antes, ajustar la IP, la puerta
   de enlace y la MAC a vuestra red.
3. Crear las instantáneas indicadas con `scripts/vm-snapshot.sh`.
4. Comprobar el resultado con los ficheros de [`sql/`](sql/README.md).

Ningún fichero contiene contraseñas: DBCA, `passwd` y el instalador de HR las piden
por teclado.

## Documentación

- **Tutorial:** compilar `tutorial/latex/main.tex` con **pdfLaTeX** (dos pasadas o
  `latexmk -pdf main.tex`). Ver [`tutorial/latex/README.md`](tutorial/latex/README.md).
- **Log de cabezazos:** [`log-cabezazos.md`](log-cabezazos.md), también incluido como
  anexo del tutorial.

## Integrantes

| Nombre | Anfitrión |
|--------|-----------|
| Alejandro Serrano Cabrera | CachyOS |
| Pedro Catalán Catalán | Debian |

## Entrega

4 de noviembre de 2026.

## Licencia

[MIT](LICENSE). Cubre únicamente los scripts y la documentación propios; el software
de Oracle y PostgreSQL tiene sus propias licencias.
