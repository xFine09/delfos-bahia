# delfos-bahia

Mini proyecto transversal de Administración de SGBDs.

Despliegue de la máquina virtualizada **delfos.inf** (Ubuntu Server LTS sobre
Qemu/KVM) con **Oracle Database XE**, siguiendo la arquitectura OFA, y creación
de la base de datos **BAHIA.inf** (SID: XE, AL32UTF8, bloque de 8 KB) con los
esquemas de ejemplo y los scripts de creación generados por DBCA.

Como ampliación, se despliega un servidor **PostgreSQL** en el mismo equipo y se
puebla uno de sus esquemas desde Oracle mediante un *database link* basado en
los servicios heterogéneos (Generic Connectivity / DG4ODBC).

## Contenido
- `tutorial/`: tutorial paso a paso (PDF y formato editable)
- `log-cabezazos.md`: problemas encontrados y sus soluciones
- `scripts/`, `config/`, `sql/`: automatización y ficheros de configuración
- `db-creation-scripts/`: scripts de creación generados por DBCA
- `software/`: enlaces y hashes de los paquetes de Oracle utilizados

## Integrantes
- Tu nombre
- Nombre de tu compañero

## Entrega
4 de noviembre de 2026
