---
borrador: workspace/03-borradores/2026-09-06-cache-reads-coste-agentico.md
veredicto: APROBADO CON CAMBIOS
caracteres: workspace/03-borradores/2026-09-06-cache-reads-coste-agentico.md  1092/1200 caracteres  [OK]  gancho: 153
fecha_revision: 2026-09-06
corrida: 001
---

## Bloqueantes

Ninguno.

Se comprobaron uno a uno los cuatro supuestos que habrían bloqueado el post y los cuatro pasan:

1. **Longitud.** 1092/1200 en el cuerpo, gancho de 153/200. Dentro del rango objetivo de la guía de voz (700-1100).
2. **Trazabilidad.** Las seis cifras del cuerpo ($10, $50, $0.25/MTok, 75%, ~25%, ~45%) y los dos nombres propios (Claude Fable 5.1, Fable 5 / Anthropic) están todos en el brief y en el informe. No hay ninguna cifra huérfana ni ninguna cita textual entrecomillada que verificar.
3. **Fuentes.** Las tres URLs del frontmatter devuelven **200**, no 404. Verificadas con fetch y con `curl -I`. El investigador había anotado 404 en `/news/claude-fable-5-1-and-claude-mythos-5-1`, `/news/how-claudes-text-watermark-works` y `/news/expanding-our-support-for-scientists`; **ninguno de esos tres slugs se usa en este post**. El borrador cita el slug corregido (`/claude-fable-and-mythos-5-1`), que sí resuelve y sí dice lo que se le atribuye, literalmente: "Cache reads now cost 75% less, or $0.25 per million tokens".
4. **"Qué NO decir" del brief.** Las cuatro prohibiciones se respetan, y tres de ellas de forma activa (ver Checklist).

## Observaciones menores

- **Dice:** "La consecuencia aplica a todos: el diseño del contexto deja de ser estilo y pasa a ser la principal palanca de coste."

  **Propongo:** "La consecuencia, si tienes agentes en producción: el diseño del contexto deja de ser estilo y pasa a ser tu principal palanca de coste."

  **Motivo:** contradice lo que el propio post acaba de establecer dos párrafos antes ("En un chat eso es un detalle"). Si en un chat el ahorro es prácticamente nulo, el diseño del contexto no es la principal palanca de coste "para todos" — lo es para quien corre bucles agénticos, que es exactamente la audiencia del brief. Tal como está es el único punto del post que invita a una corrección en comentarios ("en mi caso de chat esto no cambia nada"), y es una corrección que el autor no puede rebatir porque el post ya le dio la razón al comentarista. El cambio además vuelve a apuntar el post a su audiencia definida y añade 18 caracteres: el cuerpo pasaría de 1092 a **1110**, sigue en OK.

  **Nota de aplicación:** al aplicarlo, actualizar `caracteres: 1092` → `caracteres: 1110` en el frontmatter y volver a pasar `./config/contar.sh`.

No hay más cambios que proponer. El resto del texto se sostiene y no voy a inventar retoques de estilo: la estructura, el ritmo de párrafo, el CTA y los hashtags están bien como están.

## Tabla de trazabilidad

| Dato en el post | Origen | URL | Estado |
|---|---|---|---|
| "Claude Fable 5.1" (nombre y existencia del modelo) | brief §Rec.#1 Tema / informe §Hallazgo 1 | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado (200) |
| "$10 input y $50 output por MTok" | brief §Datos disponibles / informe §Hallazgo 1 "Dato duro" | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado — la primaria dice "$10 per million input tokens and $50 per million output tokens" |
| "El precio de lista sigue igual que en Fable 5" | brief §Ángulo / informe §Resumen ejecutivo | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado — "pricing is otherwise the same as Fable 5's" |
| "las lecturas de caché caen a $0.25/MTok" | brief §Datos disponibles / informe §Hallazgo 1 | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado — "Cache reads now cost 75% less, or $0.25 per million tokens" |
| "un 75% menos" | brief §Datos disponibles / informe §Hallazgo 1 | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado (idéntico a la primaria) |
| "Anthropic estima un coste típico ~25% menor que Fable 5" | brief §Datos disponibles / informe §Hallazgo 1 | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado — "costs are reduced by around 25% relative to Fable 5" |
| "y hasta ~45% en trabajo agéntico" | brief §Datos disponibles / informe §Hallazgo 1 | https://www.anthropic.com/claude-fable-and-mythos-5-1 | verificado — "the savings could be up to around 45%" |
| "depende de tu tasa de aciertos de caché" | brief §Qué NO decir (es la salvedad que el brief exige) | — | verificado contra el brief |
| "relee el mismo contexto decenas de veces" | brief §Ángulo, literal: "un bucle de agente lee el mismo contexto decenas de veces" | — | verificado contra el brief — cualitativo, no se presenta como medición |
| "casi todo el gasto vive del lado del caché" | inferencia del §Ángulo del brief | https://www.vellum.ai/blog/claude-fable-5-1-mythos-5-1-benchmarks-explained | verificado — la fuente independiente lo formula igual ("most of the bill in context-heavy agentic work") |
| "los límites de los planes de suscripción son otra historia" | brief §Datos disponibles (contexto de cierre) y §Qué NO decir | https://www.bleepingcomputer.com/news/artificial-intelligence/anthropic-is-cutting-claude-codes-current-weekly-limits-by-17-percent/ | verificado contra el brief — se nombra sin cifras, solo para separar las dos economías |
| System card (3ª URL del frontmatter) | brief §Datos disponibles / informe §Hallazgo 1 | https://www-cdn.anthropic.com/0339e6a7c5c7b87f5c07798616dc32c215d14235/Claude%20Fable%205.1%20&%20Claude%20Mythos%205.1%20System%20Card.pdf | verificado (200, `application/pdf`) |
| Análisis independiente (2ª URL del frontmatter) | brief §Datos disponibles / informe §Hallazgo 1 | https://www.vellum.ai/blog/claude-fable-5-1-mythos-5-1-benchmarks-explained | verificado (200) — coincide en las cuatro cifras |
| — cifras ausentes en el cuerpo — | — | — | no hay ninguna cifra sin origen: cero alucinaciones |

Fechas y citas textuales: el cuerpo **no contiene ninguna fecha** ni ninguna cita entrecomillada, así que no hay nada que rastrear en esos dos apartados. Es una decisión acertada del redactor, no una omisión.

## Checklist

| Criterio | Resultado |
|---|---|
| **[B]** Cuerpo ≤ 1200 caracteres (`contar.sh`) | OK — 1092/1200 |
| **[B]** Gancho ≤ 200 caracteres | OK — 153 |
| El gancho se sostiene solo | OK — las tres frases funcionan sin el resto y plantean la tensión completa |
| Párrafos de 1-3 líneas, separados por línea en blanco | OK — siete párrafos, ninguno pasa de 3 líneas |
| 3-5 hashtags, en línea aparte | OK — 4 (#Claude #IA #AgentesIA #CosteAPI) |
| Máximo 1 emoji | OK — ninguno |
| **[B]** Toda cifra, fecha y nombre propio rastreable | OK — ver tabla; 6/6 cifras en primaria |
| **[B]** Ninguna cita textual inventada | OK — no hay citas textuales |
| **[B]** URLs del gancho y del dato principal resuelven y dicen lo atribuido | OK — 200 en las tres; texto de la primaria coincide palabra por palabra |
| **[B]** Estimaciones atribuidas a su autor | OK — "Anthropic estima…" + "Es su estimación… no es una promesa sobre tu factura" |
| **[B]** No viola "Qué NO decir" | OK — sin "25% más barato" a secas; sin el 95.0% de SWE-bench Verified; sin ahorro prometido ni calculadora; las dos economías se separan de forma explícita |
| Al menos un dato concreto o ejemplo real | OK — $0.25/MTok y el -75% |
| Distingue hecho de opinión | OK — precio como hecho, ~25%/~45% marcado como estimación ajena |
| Respeta el ángulo, no el tema genérico | OK — el ángulo es la línea del anuncio que nadie citó, no "salió Fable 5.1" |
| La tesis del brief es reconocible | OK — reproduce casi literalmente "el diseño del contexto es la principal palanca de coste" |
| Habla a la audiencia definida | PARCIAL — ver observación menor: "aplica a todos" desenfoca a la audiencia del brief |
| Incluye el CTA | OK — el del brief, recortado; se cae "y calcula tu propio ahorro", y bien caído |
| Sin términos prohibidos | OK — ni desbloquea, ni revoluciona, ni game changer, ni "en la era de la IA" |
| Voz activa, frases cortas | OK |
| Un solo tema por post | OK — la suscripción solo se nombra para excluirla, no abre un segundo tema |
| Sin promesas de resultado | OK — "probablemente" en el gancho y desactivación explícita en el párrafo 4 |
| No envejece mal en 30 días | OK con matiz — ver Riesgos |
| No expone al autor a una corrección pública fácil | PARCIAL — ver observación menor y Riesgos |
| No repite tema de los últimos 21 días | OK — `workspace/05-publicados/` está vacío (primera ejecución) |

## Riesgos al publicar

- **Caducidad del precio (bajo, 30 días).** El post se apoya en una tabla de precios vigente desde el 2026-09-01. Si Anthropic la mueve, el post queda desfasado sin decirlo, porque no lleva fecha en el cuerpo. No propongo añadirla — cuesta caracteres y el post se lee como comentario de actualidad —, pero conviene tenerlo presente si se recicla el texto más adelante.
- **El gancho es una paradoja deliberada (bajo).** "El precio de Claude Fable 5.1 no bajó" es falso en sentido estricto: el precio de las lecturas de caché sí bajó. El propio gancho lo resuelve en la tercera frase y LinkedIn muestra las 153 caracteres enteras antes del "ver más", así que el lector nunca ve la mitad de la paradoja. Riesgo asumible; era el planteamiento del brief.
- **"una línea del anuncio que casi nadie citó" (bajo).** Es una afirmación sobre la cobertura ajena que nadie ha medido. Viene del gancho sugerido en el brief y funciona como retórica, pero si alguien responde con tres artículos que sí lo citaron, no hay defensa. No propongo cambiarlo; sí conviene que el autor lo sepa antes de publicar.
- **"aplica a todos" (medio).** Es el único punto donde el post se contradice a sí mismo y regala una corrección en comentarios. Es la observación menor de arriba; aplicarla lo cierra.
- **Falta el "cómo" del ángulo (informativo, no bloqueante).** El ángulo del brief pedía también "cómo estructurar el prompt para que ese contexto caiga del lado barato". El post nombra la palanca pero no la acciona: sustituye el cómo por el CTA de medir el ratio de aciertos. Con 108 caracteres de margen no cabía, y forzarlo rompería la regla de un tema por post. Lo dejo constatado por si el estratega quiere un post de continuación con esa mitad — no es un defecto de este borrador.
- **Sin riesgo reputacional ni de exposición.** No hay acusaciones, ni comparativas entre laboratorios, ni cifras de terceros sin auditar, ni testimonios de comunidad. El post no compromete al autor más allá de su lectura del anuncio.
