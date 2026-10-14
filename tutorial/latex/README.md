# Tutorial en LaTeX

- `main.tex`: preámbulo, portada, índice e introducción; reúne el resto con `\input`.
- `Semana1.tex`: Apartado 1, preparación del entorno (VM, Ubuntu Server y OFA).
- `Semana2.tex`: Apartado 2, instalación de Oracle XE 21c y creación de BAHIA.inf.
- `Cabezazos.tex`: anexo con el log de cabezazos de todas las semanas.
- `Images/SemanaN/`: capturas de cada semana.
- `main.pdf`: vista previa compilada.

Se compila solo `main.tex`, dos veces: `pdflatex main.tex`.

Para añadir una semana nueva: crear `SemanaN.tex`, la carpeta `Images/SemanaN/`,
añadir la carpeta a `\graphicspath` y la línea `\input{SemanaN}` en `main.tex`.
Los cabezazos nuevos se añaden como filas en `Cabezazos.tex`.
