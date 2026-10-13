# Tutorial en LaTeX

- `main.tex`: documento principal (compilar dos veces con `pdflatex main.tex`).
- `estilo.tex`: paquetes, estilos de código y cajas de "cabezazo".
- `semana2.tex`: instalación de Oracle XE 21c y creación de BAHIA.inf.
- `cabezazos.tex`: log de cabezazos de todas las fases.
- `img/semana2/`: capturas de la semana 2.

Para integrarlo en otro documento: `\input{estilo}` en el preámbulo e
`\input{semana2}` / `\input{cabezazos}` en el cuerpo.
Requiere `texlive-lang-spanish` para el idioma (si no está, usa títulos en español igualmente).
