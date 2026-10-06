# delfos-bahia

Mini proyecto transversal de Administración de SGBDs (ASGBD).

Despliegue de la máquina virtualizada **delfos.inf** (Ubuntu Server LTS sobre
Qemu/KVM) con **Oracle Database XE**, siguiendo la arquitectura OFA, y creación
de la base de datos **BAHIA.inf** (SID: `XE`, juego de caracteres `AL32UTF8`,
bloque de 8 KB) con los esquemas de ejemplo y los scripts de creación generados
por DBCA.

Como ampliación, se despliega un servidor **PostgreSQL** en el mismo equipo y se
puebla uno de sus esquemas desde Oracle mediante un *database link* basado en
los servicios heterogéneos (Generic Connectivity / DG4ODBC).

## Datos clave

| Elemento            | Valor                                  |
|---------------------|----------------------------------------|
| Máquina virtual     | `delfos.inf` (Ubuntu Server LTS, Qemu/KVM) |
| SGBD principal      | Oracle Database XE                     |
| Base de datos       | `BAHIA.inf` (SID `XE`)                 |
| Charset / bloque    | `AL32UTF8` / 8 KB                      |
| Arquitectura        | OFA (Optimal Flexible Architecture)    |
| Ampliación          | PostgreSQL + DB link vía DG4ODBC       |

## Estructura del repositorio

```
delfos-bahia/
├── tutorial/             Tutorial paso a paso (PDF y formato editable)
├── log-cabezazos.md      Problemas encontrados y sus soluciones
├── scripts/              Scripts de automatización (shell)
├── config/               Ficheros de configuración (listener, tnsnames, odbc...)
├── sql/                  Scripts SQL (esquemas de ejemplo, DB link, etc.)
├── db-creation-scripts/  Scripts de creación generados por DBCA
├── software/             Enlaces y hashes de los paquetes de Oracle utilizados
└── LICENSE
```

## Fases del proyecto

1. Creación de la VM `delfos.inf` (Qemu/KVM, Ubuntu Server LTS).
2. Instalación de Oracle Database XE con estructura de directorios OFA.
3. Creación de `BAHIA.inf` con DBCA y conservación de sus scripts.
4. Carga de los esquemas de ejemplo.
5. Ampliación: instalación de PostgreSQL y DB link Oracle → PostgreSQL (DG4ODBC).
6. Documentación (tutorial y log de problemas).

Estado: ☐ 1 ☐ 2 ☐ 3 ☐ 4 ☐ 5 ☐ 6

## Cómo usar este repositorio

1. Descargar el software indicado en [`software/README.md`](software/README.md)
   y verificar los hashes.
2. Seguir el [tutorial](tutorial/README.md).
3. Los scripts de `scripts/` se ejecutan en orden numérico.
4. Anotar cualquier incidencia en [`log-cabezazos.md`](log-cabezazos.md).

## Integrantes
- Tu nombre
- Nombre de tu compañero

## Entrega
4 de noviembre de 2026
