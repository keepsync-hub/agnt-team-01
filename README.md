# Equipo de 5 agentes — contenido sobre Claude para LinkedIn

## Estructura

```
CLAUDE.md                     el protocolo del equipo: llega a los 5 agentes siempre
.claude/
  agents/                     definiciones de los 5 agentes (procedimiento)
    coordinador.md  investigador-claude.md  estratega-temas.md
    redactor-linkedin.md  editor-calidad.md
  commands/
    pipeline-linkedin.md      /pipeline-linkedin  → corre las 4 fases
  settings.json               engancha el gate de publicación
politicas/                    política por fase: lo que se edita a menudo
  00-coordinador.md           umbrales, reanudación, cierre de pendientes
  01-fuentes.md               lista de fuentes a barrer
  02-editorial.md             criterios editoriales y scoring
  03-voz-y-tono.md            voz, tono y rango de longitud
  03-post-base.md             plantilla de post
  04-checklist.md             checklist de calidad (marca los bloqueantes)
workspace/                    una etapa por agente
  00-bitacora/                registro.md + corridas/  histórico de ejecuciones
  01-investigacion/           informes de tendencias
  02-temas/                   agendas editoriales
  03-borradores/              posts pendientes
  04-revisiones/              veredictos del editor
  05-publicados/              histórico (evita repetir temas)
config/
  contar.sh                   conteo del cuerpo y del gancho; falla si se pasan
  estado.sh                   qué hay en cada etapa y qué está atascado
  pruebas.sh                  pruebas de las tres piezas de aquí
  hooks/gate-publicacion.sh   deniega publicar sin veredicto APROBADO
```

**Por qué dos sitios y no uno.** `.claude/agents/` es el *procedimiento* de cada agente y se
carga siempre; `politicas/` es la *política* que cambia a menudo y se lee bajo demanda. Lo
que comparten los cinco no está en ninguno de los dos: está en `CLAUDE.md`, que la
plataforma inyecta entero en cada subagente. Nada se enuncia en dos sitios a la vez, salvo
las reglas de seguridad, que se repiten a propósito en cada agente que toca la red.

## Uso

Ver dónde está el trabajo:

```bash
./config/estado.sh
```

Pipeline completo (lo orquesta el coordinador):

```bash
/pipeline-linkedin Claude Code
```

O un agente suelto, pidiéndolo por nombre:
`"usa el subagente estratega-temas con el informe de ayer"`

Validar longitud de un borrador:

```bash
./config/contar.sh workspace/03-borradores/*.md
```

El script cuenta solo el cuerpo del post (ignora frontmatter y notas) y sale con código 1
si el cuerpo pasa de 1200 **o** el gancho de 200. Si el archivo declara `caracteres:` en su
frontmatter, avisa cuando ya no cuadra con el texto.

Antes de tocar nada de `config/`:

```bash
./config/pruebas.sh
```

## Puerta de calidad

`editor-calidad` cierra el pipeline y emite uno de tres veredictos:

| Veredicto | Qué pasa |
|---|---|
| `APROBADO` | listo para el humano |
| `APROBADO CON CAMBIOS` | observaciones menores con texto exacto de reemplazo |
| `RECHAZADO` | vuelve al redactor (máximo 2 vueltas) |

Es bloqueante que una cifra no sea rastreable hasta el informe o el brief, que una URL
esté rota, que una estimación se presente como hecho, o que se viole el "Qué NO decir".

La regla no se queda en la prosa: un hook `PreToolUse` (`config/hooks/gate-publicacion.sh`)
deniega cualquier escritura o `mv` hacia `05-publicados/` si la revisión de número más alto
de ese post no dice `APROBADO`. Atrapa el fallo realista —un agente que se equivoca—; no
pretende ser una frontera de seguridad.

## Publicar

Publicar es **mover**: el borrador sale de `03-borradores/` y entra en `05-publicados/` con
`estado: publicado` y `publicado: YYYY-MM-DD`. Lo que queda en `03-borradores/` es, por
definición, lo pendiente. Lo hace el humano, nunca un agente.
