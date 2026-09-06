# Políticas de orquestación

## Umbrales
| Situación | Acción |
|---|---|
| Editor devuelve `RECHAZADO` | reintento; máximo 2 vueltas |
| 3er rechazo del mismo borrador | abortar y reportar: el tema no se sostiene |
| Fase entrega archivo vacío o inexistente | abortar la corrida, registrar el fallo |
| Investigador no encuentra nada de los últimos 30 días | avisar antes de gastar la fase 2 |
| Agenda sin ninguna recomendación con dato verificado | parar: no hay post publicable |

## Qué decide el humano, siempre
- Qué tema de la agenda se desarrolla.
- Si se aplican los cambios de un `APROBADO CON CAMBIOS`.
- Publicar y mover a `05-publicados/`.

## Qué decide el coordinador
- Qué fase toca según `./config/estado.sh`.
- Si hay que repetir una fase por entrega defectuosa.
- Cuándo abortar.

## Retomar una corrida a medias
1. `./config/estado.sh` para ver la última etapa con artefacto.
2. Abrir el detalle de la corrida en `workspace/00-bitacora/corridas/` y leer dónde se cortó.
3. Reanudar desde la fase siguiente. No re-ejecutar fases ya completadas salvo que su
   salida esté vacía o el humano lo pida.
