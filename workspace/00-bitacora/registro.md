# Registro maestro de corridas

> **Append-only.** Este archivo solo crece: cada corrida cerrada añade una fila al final de
> la tabla. **Nunca se reescriben ni se corrigen filas pasadas** — si un dato de una corrida
> anterior resultó equivocado, se anota en el detalle de esa corrida
> (`workspace/00-bitacora/corridas/`) y, si procede, en la fila de la corrida siguiente.
> El valor de esta tabla está en que refleja lo que pasó, no lo que nos habría gustado que pasara:
> también se registran los fallos, los rechazos y las desviaciones del procedimiento.
>
> El detalle de cada corrida vive en `workspace/00-bitacora/corridas/YYYY-MM-DD-corrida-NNN.md`.

| Corrida | Fecha | Foco | Fases | Tema elegido | Veredicto | Caracteres | Estado |
|---|---|---|---|---|---|---|---|
| 001 | 2026-09-06 | Tendencias generales sobre Claude, sin foco acotado (primera ejecución del pipeline) | 1-4 | Recomendación #1 (43.5/45) — el recorte del 75% en lecturas de caché de Claude Fable 5.1 y el coste real de un agente | APROBADO CON CAMBIOS | 1092 | cerrada — pendiente de decisión humana (aplicar cambio y publicar) |
| 002 | 2026-09-06 | Cierre del borrador de la 001: aplicar la observación menor del editor y revalidar (corrida parcial, continúa la 001) | 3-4 | El mismo de la 001 — cache reads de Claude Fable 5.1 y el coste real de un agente (no se eligió tema nuevo) | APROBADO (rev 2, sin observaciones nuevas) | 1110 | cerrada — aprobado, pendiente solo de la decisión humana de publicar |
| 003 | 2026-09-06 | Revisión estructural del repo y optimización como equipo coordinado de agentes (corrida de mantenimiento: ninguna fase editorial) | — | Ninguno: no se produjo contenido | — | — | cerrada — cierra el pendiente técnico de la 002 sobre `ult()`; el borrador sigue aprobado y sin publicar |

---

### Notas al pie

**Sobre la fila 001 y su relación con la 002.** La fila de la corrida 001 registra `APROBADO CON
CAMBIOS`, 1092 caracteres y "pendiente de decisión humana (aplicar cambio y publicar)". Eso dejó de
describir el estado actual del borrador el 2026-09-06, cuando la corrida 002 aplicó el cambio y el
editor lo revalidó como `APROBADO` con 1110 caracteres. **La fila 001 no se corrige, y es correcto
que no se corrija:** describe cómo terminó la corrida 001, que es exactamente lo que esa fila
registra. El estado vigente del borrador es siempre el de la **última** fila que lo menciona — hoy,
la 002.

**Corridas parciales.** La 002 es la primera corrida que no ejecuta las cuatro fases. Ejecutó solo
las fases 3 y 4 sobre el artefacto de la 001; las fases 1 y 2 no se repitieron porque sus salidas
seguían vigentes y no se eligió tema nuevo. La columna "Fases" lo refleja como `3-4`. Esto es el
procedimiento de "retomar una corrida a medias" de `agents/00-coordinador/politicas/orquestacion.md`,
no una omisión de fases.

**Incidencia de herramienta registrada en la 002.** `config/estado.sh` mostraba un veredicto obsoleto
cuando existía más de una revisión del mismo borrador (leía siempre `.revision.md`). Corregido en esa
corrida para tomar la revisión más reciente por `mtime` y mostrar el contador de revisiones. Se anota
aquí porque afecta a la fiabilidad del panel con el que se decide qué fase toca, no a un agente
concreto. Detalle en `workspace/00-bitacora/corridas/2026-09-06-corrida-002.md`.
