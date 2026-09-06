---
borrador: workspace/03-borradores/2026-09-06-cache-reads-coste-agentico.md
revision: 2 (revalidación)
parte_de: workspace/04-revisiones/2026-09-06-cache-reads-coste-agentico.revision.md (revisión 1, veredicto APROBADO CON CAMBIOS)
alcance: revalidación acotada — aplicación de la única observación menor de la revisión 1
veredicto: APROBADO
caracteres: workspace/03-borradores/2026-09-06-cache-reads-coste-agentico.md  1110/1200 caracteres  [OK]  gancho: 153
fecha_revision: 2026-09-06
---

## Alcance y qué se hereda

Esta es una **revalidación**, no una auditoría nueva. La revisión 1 (mismo día, mismo
material) dio APROBADO CON CAMBIOS con una única observación menor; el humano autorizó
aplicarla y el redactor la aplicó. Aquí solo se comprueba esa aplicación.

**Se hereda íntegra de la revisión 1, sin repetir:**

- La **verificación de URLs con WebFetch/`curl`**: las tres URLs del frontmatter
  devolvieron 200 y la primaria decía literalmente lo que se le atribuye. El frontmatter
  `fuentes:` es byte a byte el mismo de ayer — mismas tres URLs, mismo orden —, así que
  no hay nada que revalidar.
- La **tabla de trazabilidad completa** (14 filas, 6/6 cifras en fuente primaria, cero
  alucinaciones, cero citas textuales, cero fechas en el cuerpo). El cambio aplicado no
  introduce ni retira ninguna cifra, fecha, nombre propio ni cita, de modo que la tabla
  de la revisión 1 sigue siendo válida sin una sola modificación.
- Los **riesgos al publicar** enumerados en la revisión 1 (caducidad del precio, el gancho
  como paradoja deliberada, "una línea que casi nadie citó", y la mitad del ángulo —el
  "cómo"— que queda fuera). Todos siguen igual, salvo uno, que este cambio cierra: ver abajo.

## Bloqueantes

Ninguno.

## 1. Longitud — salida literal de `./config/contar.sh`

```
workspace/03-borradores/2026-09-06-cache-reads-coste-agentico.md  1110/1200 caracteres  [OK]  gancho: 153
```

Dentro de límites. Cuerpo 1110/1200 (90 de margen), gancho 153/200. La revisión 1 había
predicho exactamente 1110 al aplicar el cambio; el número coincide.

## 2. El cambio aplicado es exactamente el propuesto

| | Texto |
|---|---|
| **Antes (rev. 1)** | `La consecuencia aplica a todos: el diseño del contexto deja de ser estilo y pasa a ser la principal palanca de coste.` |
| **Propuse (rev. 1)** | `La consecuencia, si tienes agentes en producción: el diseño del contexto deja de ser estilo y pasa a ser tu principal palanca de coste.` |
| **Está (borrador)** | `La consecuencia, si tienes agentes en producción: el diseño del contexto deja de ser estilo y pasa a ser tu principal palanca de coste.` |

Comprobado con coincidencia literal de línea completa (`grep -Fxq`): **1 ocurrencia exacta**,
palabra por palabra, incluida la coma tras "consecuencia", los dos puntos, la tilde de
"producción" y el posesivo "tu". De la frase antigua **no queda ningún rastro** en el archivo.

Aritmética: frase nueva 135 caracteres, frase vieja 117. Delta **+18**, exactamente los 18
que anuncié. 1092 + 18 = 1110.

## 3. Nada más se tocó en el cuerpo

Dos comprobaciones independientes, ambas pasan.

**a) Prueba de reversión.** Revertí en una copia de trabajo *solo* esa frase (frase nueva →
frase vieja) y volví a pasar `contar.sh`:

```
…/revertido.md  1092/1200 caracteres  [OK]  gancho: 153
```

Reproduce **1092 y gancho 153**, los dos números exactos que registró la revisión 1. Si el
redactor hubiera cambiado cualquier otra cosa del cuerpo, este número no cuadraría (haría
falta un par de ediciones compensadas que sumaran cero para engañarlo, y el cotejo de
abajo lo descarta).

**b) Cotejo frase a frase** contra los fragmentos citados en la revisión 1. Los once
fragmentos que la revisión 1 recoge —gancho completo, los siete párrafos y la línea de
hashtags— se buscaron literalmente en el borrador. **Once de once presentes, sin variación:**

| Fragmento citado en la revisión 1 | Estado |
|---|---|
| "El precio de Claude Fable 5.1 no bajó. Tu factura, si corres agentes, probablemente sí. La diferencia está en una línea del anuncio que casi nadie citó." | idéntico |
| "El precio de lista sigue igual que en Fable 5: $10 input y $50 output por MTok." | idéntico |
| "Lo que cambió está debajo: las lecturas de caché caen a $0.25/MTok, un 75% menos." | idéntico |
| "En un chat eso es un detalle." | idéntico |
| "En un bucle de agente no: relee el mismo contexto decenas de veces, así que casi todo el gasto vive del lado del caché." | idéntico |
| "Anthropic estima un coste típico ~25% menor que Fable 5, y hasta ~45% en trabajo agéntico." | idéntico |
| "Es su estimación, y depende de tu tasa de aciertos de caché: no es una promesa sobre tu factura." | idéntico |
| "Y no mezcles economías. Esto es la API por token; los límites de los planes de suscripción son otra historia." | idéntico |
| "Saca el desglose de cache-read vs input de tu última factura." | idéntico |
| "Si no conoces tu ratio de aciertos, ese es el número que deberías medir esta semana. Responde con el tuyo y comparo." | idéntico |
| "#Claude #IA #AgentesIA #CosteAPI" | idéntico |

Estructura intacta: siete párrafos más la línea de hashtags aparte, separados por línea en
blanco, ninguno de más de 3 líneas. Cero emojis en el cuerpo (verificado por barrido de
caracteres, no solo a ojo). Cuatro hashtags.

**Conclusión: no hay ningún cambio no autorizado.** El redactor tocó una frase y solo una.

**Único añadido fuera del cuerpo, y es correcto:** una entrada de changelog en "Notas de
revisión" (línea 36) que registra el cambio, cita la revisión 1 por ruta y declara "Resto del
texto sin tocar". Está tras el separador `---`, no cuenta caracteres, no se publica y es
exactamente la traza que debe dejarse. No es un hallazgo; lo dejo constatado para que quede
claro que lo vi y lo di por bueno.

## 4. El cambio no introduce ningún problema nuevo

- **Contradicción interna: resuelta, ninguna creada.** El motivo de la observación era el
  choque con "En un chat eso es un detalle" dos párrafos antes. Con el nuevo condicional
  ("si tienes agentes en producción") las dos frases dicen lo mismo: en chat es marginal,
  en bucle agéntico es la palanca. Repasado el resto del cuerpo frase a frase, la nueva
  redacción no entra en conflicto con ninguna otra afirmación. El párrafo siguiente
  ("Y no mezcles economías…") sigue encajando sin costura, y el CTA —que ya se dirigía a
  quien tiene una factura de API con desglose de cache-read— ahora tiene el sujeto
  explícito dos párrafos antes.
- **Ángulo del brief: no se pierde, se afina.** El brief define la audiencia como
  "desarrolladores y líderes técnicos que ya tienen agentes o pipelines multi-turno en
  producción". "Si tienes agentes en producción" es esa audiencia, casi literal. La tesis
  del brief ya venía acotada a "un sistema agéntico", así que el condicional la reproduce
  mejor que el "aplica a todos" anterior, que la sobreextendía.
- **"Qué NO decir": las cuatro prohibiciones siguen respetadas.** La frase nueva no
  introduce ningún porcentaje, no menciona el 95.0% de SWE-bench Verified, no promete un
  ahorro concreto al lector ni añade calculadora, y no mezcla la economía de API con la de
  suscripción. "Palanca de coste" describe dónde está el control, no promete un resultado:
  no cae en "sin promesas de resultado".
- **Voz.** Sin términos prohibidos, voz activa, frase corta, un solo tema. El posesivo
  "tu" mantiene el registro de segunda persona que usa todo el post.

## 5. Frontmatter

`caracteres: 1110` coincide con lo medido por `contar.sh` (1110). El redactor actualizó el
campo como pedía la nota de aplicación de la revisión 1. `tema:`, `fuentes:` y
`estado: borrador` sin cambios.

## Checklist (solo lo que este cambio podía alterar)

| Criterio | Resultado |
|---|---|
| **[B]** Cuerpo ≤ 1200 caracteres (`contar.sh`) | OK — 1110/1200 |
| **[B]** Gancho ≤ 200 caracteres | OK — 153 (sin tocar) |
| **[B]** Toda cifra/fecha/nombre propio rastreable | OK — heredado; el cambio no toca ninguna |
| **[B]** Estimaciones atribuidas a su autor | OK — heredado; el párrafo de "Anthropic estima…" intacto |
| **[B]** URLs resuelven y dicen lo atribuido | OK — heredado de la revisión 1, mismas tres URLs |
| **[B]** No viola "Qué NO decir" | OK — reverificado contra las cuatro prohibiciones |
| Párrafos de 1-3 líneas, separados por línea en blanco | OK — 7 párrafos + hashtags |
| 3-5 hashtags en línea aparte | OK — 4 |
| Máximo 1 emoji | OK — ninguno |
| Habla a la audiencia definida | **OK — era el único PARCIAL de la revisión 1; queda resuelto** |
| No expone al autor a una corrección pública fácil | **OK — el otro PARCIAL de la revisión 1; queda resuelto** |
| La tesis del brief es reconocible | OK — ahora con el alcance que el propio brief le da |
| Distingue hecho de opinión | OK — sin cambios |
| Sin promesas de resultado | OK — "palanca de coste" no promete cifra |
| Frontmatter `caracteres:` coincide con lo medido | OK — 1110 = 1110 |

## Riesgos al publicar

Los de la revisión 1, **menos uno**. El riesgo catalogado allí como medio —"aplica a todos",
el único punto donde el post se contradecía y regalaba una corrección en comentarios— queda
cerrado. Los tres restantes (caducidad del precio a 30 días, el gancho como paradoja
deliberada, y "una línea que casi nadie citó" como afirmación no medida sobre la cobertura
ajena) siguen tal cual, todos bajos y todos ya asumidos conscientemente en la revisión 1.
No hay riesgo nuevo introducido por el cambio.

## Veredicto

**APROBADO.** El cambio autorizado se aplicó literalmente, no se tocó nada más, el
frontmatter cuadra y el post sigue dentro de límites. No tengo observaciones nuevas y no voy
a fabricar ninguna para justificar esta pasada: el borrador está listo para el humano.

*(No he publicado nada ni he modificado el borrador.)*
