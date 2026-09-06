# Equipo de 5 agentes — contenido sobre Claude para LinkedIn

## Estructura

```
.claude/
  agents/                     definiciones de los 5 agentes
    coordinador.md
    investigador-claude.md
    estratega-temas.md
    redactor-linkedin.md
    editor-calidad.md
  commands/
    pipeline-linkedin.md      /pipeline-linkedin  → corre las 4 fases
agents/                       un directorio por agente, misma forma todos
  00-coordinador/prompts/     + politicas/   umbrales y reglas de orquestación
  01-investigador/prompts/    + fuentes/     lista de fuentes a barrer
  02-estratega/prompts/       + criterios/   criterios editoriales y scoring
  03-redactor/prompts/        + plantillas/  voz, tono y plantilla de post
  04-editor/prompts/          + criterios/   checklist de calidad (marca bloqueantes)
workspace/                    una etapa por agente
  00-bitacora/                registro.md + corridas/  histórico de ejecuciones
  01-investigacion/           informes de tendencias
  02-temas/                   agendas editoriales
  03-borradores/              posts pendientes
  04-revisiones/              veredictos del editor
  05-publicados/              histórico (evita repetir temas)
config/
  contar.sh                   valida el límite de 1200 caracteres
  estado.sh                   qué hay en cada etapa y qué está atascado
docs/
```

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

El script cuenta solo el cuerpo del post (ignora frontmatter y notas),
sale con código 1 si excede 1200 y muestra también el largo del gancho.

## Puerta de calidad

`editor-calidad` cierra el pipeline y emite uno de tres veredictos:

| Veredicto | Qué pasa |
|---|---|
| `APROBADO` | listo para el humano |
| `APROBADO CON CAMBIOS` | observaciones menores con texto exacto de reemplazo |
| `RECHAZADO` | vuelve al redactor (máximo 2 vueltas) |

Es bloqueante que una cifra no sea rastreable hasta el informe o el brief, que una URL
esté rota, que una estimación se presente como hecho, o que se viole el "Qué NO decir".
