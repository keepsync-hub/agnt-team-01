# agnt-team-01 — Pipeline de contenido sobre Claude para LinkedIn

Cuatro agentes encadenados: **investigar → elegir tema → redactar → editar**,
más un **coordinador** que los lanza y lleva la bitácora.

## Agentes
| # | Agente | Entrada | Salida |
|---|---|---|---|
| 0 | `coordinador` | el estado del workspace | `workspace/00-bitacora/` |
| 1 | `investigador-claude` | la web | `workspace/01-investigacion/` |
| 2 | `estratega-temas` | informe de (1) | `workspace/02-temas/` |
| 3 | `redactor-linkedin` | agenda de (2) | `workspace/03-borradores/` |
| 4 | `editor-calidad` | borrador de (3) + brief + informe | `workspace/04-revisiones/` |

Se definen en `.claude/agents/`. Se invocan por nombre, o se deja al `coordinador`
que orqueste la corrida entera con `/pipeline-linkedin`.

## Estado del pipeline
```bash
./config/estado.sh
```
Dice qué hay en cada etapa y qué está atascado (sin revisar, rechazado, aprobado sin publicar).
El coordinador lo ejecuta **antes** de decidir qué fase toca. Nunca asumas el estado: míralo.

## Reglas duras
- Todo post de LinkedIn: **máximo 1200 caracteres** en el cuerpo.
  Se verifica con `./config/contar.sh <archivo>` — nunca "a ojo".
- **Nada pasa a `05-publicados/` sin veredicto `APROBADO` del editor.**
  Un dato sin fuente rastreable es bloqueante, por bien escrito que esté el post.

## Convenciones
- Archivos con prefijo de fecha `YYYY-MM-DD-`.
- Los datos viajan con su URL desde la fase 1 hasta la 4. Sin fuente, no se publica.
- Al publicar, mover el borrador de `03-borradores/` a `05-publicados/` y poner `estado: publicado`.
- El editor no reescribe: propone el texto exacto y el redactor lo aplica.
- El coordinador no investiga ni escribe: delega y registra. Toda corrida deja rastro
  en `workspace/00-bitacora/`, incluidos los fallos y los rechazos.
- Ningún agente publica en redes. El último paso siempre es humano.
