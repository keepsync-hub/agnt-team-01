---
description: Ejecuta el pipeline completo investigación → tema → post → edición
argument-hint: [foco opcional, ej. "Claude Code" o "agentes"]
allowed-tools: Task, Read, Write, Bash
---

Delega en el subagente `coordinador`: que ejecute las cuatro fases **en orden**, esperando el resultado de cada una antes de lanzar la siguiente.
Foco de esta ronda: $ARGUMENTS (si está vacío, cubre tendencias generales sobre Claude).

1. Lanza el subagente `investigador-claude`. Debe dejar su informe en `workspace/01-investigacion/`.
2. Con ese informe, lanza `estratega-temas`. Debe dejar la agenda en `workspace/02-temas/`.
3. Muéstrame las recomendaciones y **pregúntame cuál desarrollar** antes de continuar.
4. Con el tema elegido, lanza `redactor-linkedin`. Debe dejar el borrador en `workspace/03-borradores/`.
5. Lanza `editor-calidad` sobre ese borrador. Debe dejar su revisión en `workspace/04-revisiones/`.
6. Según el veredicto:
   - `RECHAZADO` → devuelve el borrador y la revisión al `redactor-linkedin` para que corrija,
     y vuelve a pasar por `editor-calidad`. **Máximo 2 vueltas**; si a la tercera sigue rechazado,
     párate y explícame por qué el tema no se sostiene.
   - `APROBADO CON CAMBIOS` → muéstrame los cambios propuestos y pregúntame si los aplico.
   - `APROBADO` → sigue.
7. Corre `./config/contar.sh` sobre el borrador final y reporta el número real de caracteres.
8. Asegúrate de que el coordinador ha cerrado la corrida en `workspace/00-bitacora/`.
9. Entrégame el post en el chat, listo para copiar, junto al veredicto del editor.
   **No lo publiques en ningún sitio.**
