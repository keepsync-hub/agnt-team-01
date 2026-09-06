---
tema: El recorte del 75% en lecturas de caché de Claude Fable 5.1 y lo que cambia en el coste real de un agente
caracteres: 1110
fuentes: https://www.anthropic.com/claude-fable-and-mythos-5-1 · https://www-cdn.anthropic.com/0339e6a7c5c7b87f5c07798616dc32c215d14235/Claude%20Fable%205.1%20&%20Claude%20Mythos%205.1%20System%20Card.pdf · https://www.vellum.ai/blog/claude-fable-5-1-mythos-5-1-benchmarks-explained
estado: borrador
---

El precio de Claude Fable 5.1 no bajó. Tu factura, si corres agentes, probablemente sí. La diferencia está en una línea del anuncio que casi nadie citó.

El precio de lista sigue igual que en Fable 5: $10 input y $50 output por MTok. Lo que cambió está debajo: las lecturas de caché caen a $0.25/MTok, un 75% menos.

En un chat eso es un detalle. En un bucle de agente no: relee el mismo contexto decenas de veces, así que casi todo el gasto vive del lado del caché.

Anthropic estima un coste típico ~25% menor que Fable 5, y hasta ~45% en trabajo agéntico. Es su estimación, y depende de tu tasa de aciertos de caché: no es una promesa sobre tu factura.

La consecuencia, si tienes agentes en producción: el diseño del contexto deja de ser estilo y pasa a ser tu principal palanca de coste.

Y no mezcles economías. Esto es la API por token; los límites de los planes de suscripción son otra historia.

Saca el desglose de cache-read vs input de tu última factura. Si no conoces tu ratio de aciertos, ese es el número que deberías medir esta semana. Responde con el tuyo y comparo.

#Claude #IA #AgentesIA #CosteAPI

---
### Variantes de gancho
1. Casi todo el mundo leyó "$10/$50, igual que Fable 5" y cerró la pestaña. La línea que mueve la factura de un agente estaba tres renglones más abajo.
2. Las lecturas de caché de Fable 5.1 bajan un 75%, a $0.25/MTok. Si tienes agentes en producción, esa cifra vale más que cualquier benchmark de esta semana.

### Notas de revisión
- Afirmaciones que requieren verificación humana:
  - Precios $10/$50 por MTok y cache reads $0.25/MTok (-75%): confirmar en la página de producto de Anthropic antes de publicar.
  - El ~25% / ~45% es coste típico **estimado por Anthropic**, dependiente del patrón de uso. En el post va atribuido y con la salvedad del ratio de aciertos: no eliminar esa atribución al editar.
- "Relee el mismo contexto decenas de veces" es una descripción cualitativa del patrón agéntico, no una medición del brief. Si se quiere una cifra ahí, hay que medirla en propio antes.
- Deliberadamente fuera, según "Qué NO decir" de la agenda: el 95.0% en SWE-bench Verified (no es fuente primaria); cualquier promesa de ahorro concreto al lector o calculadora con números propios; y la mezcla con el recorte de cuotas de los planes de suscripción, que aquí solo se nombra para separarla.
- Sin emoji (opción válida según la definición del agente). 4 hashtags.
- 2026-09-06: aplicada la observación menor del editor (revisión `workspace/04-revisiones/2026-09-06-cache-reads-coste-agentico.revision.md`): "La consecuencia aplica a todos…" → "La consecuencia, si tienes agentes en producción… tu principal palanca de coste". Resto del texto sin tocar.
- Contrapunto disponible por si un comentario lo pide: la subida prevista de Sonnet 5 a $3/$15 el 1-sep-2026 no se aplicó; el introductorio de $2/$10 pasó a estándar.
