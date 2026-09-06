#!/usr/bin/env bash
# Pruebas de las herramientas compartidas del equipo. Los agentes confían en que
# contar.sh, estado.sh y el gate de publicación digan la verdad: si mienten, el
# editor aprueba un post fuera de límite o el coordinador lee el veredicto de la
# revisión equivocada. Tres de estos casos son bugs que ya ocurrieron de verdad.
#
#   ./config/pruebas.sh
set -uo pipefail
raiz=$(cd "$(dirname "$0")/.." && pwd)
cd "$raiz"

ok=0; fallos=0
comprobar() { # <descripción> <esperado> <obtenido>
  if [ "$2" = "$3" ]; then
    ok=$((ok+1)); printf '  ok    %s\n' "$1"
  else
    fallos=$((fallos+1)); printf '  FALLA %s\n        esperaba: %s\n        obtuvo:   %s\n' "$1" "$2" "$3"
  fi
}

caja=$(mktemp -d); trap 'rm -rf "$caja"' EXIT
post() { # <archivo> <cuerpo>
  printf -- '---\ntema: prueba\nestado: borrador\n---\n%s\n' "$2" > "$1"
}

echo "== contar.sh =="

# Las tildes y la ñ son un carácter, no dos. (Bug real: LC_ALL fijado a un locale
# que no existía en la máquina hacía que wc -m contara bytes.)
post "$caja/tildes.md" "$(python3 -c "print('á'*300)")"
n=$(./config/contar.sh "$caja/tildes.md" 2>/dev/null | awk '{print $2}')
comprobar "cuenta caracteres, no bytes" "300/1200" "$n"

# El cuerpo se corta en el separador de notas y no cuenta el frontmatter.
printf -- '---\ntema: x\n---\nhola\n\n---\n### Notas\n- esto no cuenta\n' > "$caja/notas.md"
n=$(./config/contar.sh "$caja/notas.md" 2>/dev/null | awk '{print $2}')
comprobar "ignora frontmatter y notas" "4/1200" "$n"

# Un archivo sin frontmatter es todo cuerpo.
printf 'hola\n' > "$caja/plano.md"
n=$(./config/contar.sh "$caja/plano.md" 2>/dev/null | awk '{print $2}')
comprobar "archivo sin frontmatter" "4/1200" "$n"

# Pasarse del cuerpo es fallo, no una nota informativa.
post "$caja/largo.md" "$(python3 -c "print('a'*1300)")"
./config/contar.sh "$caja/largo.md" >/dev/null 2>&1
comprobar "cuerpo de 1300 sale con error" "1" "$?"

# Y pasarse del gancho también: es lo único que LinkedIn enseña antes del "ver más".
post "$caja/gancho.md" "$(python3 -c "print('a'*210)")$(printf '\n\nresto corto')"
./config/contar.sh "$caja/gancho.md" >/dev/null 2>&1
comprobar "gancho de 210 sale con error" "1" "$?"

# Un gancho justo en el límite pasa (no hay off-by-one por el salto de línea).
post "$caja/borde.md" "$(python3 -c "print('a'*200)")$(printf '\n\nresto corto')"
./config/contar.sh "$caja/borde.md" >/dev/null 2>&1
comprobar "gancho de 200 exactos pasa" "0" "$?"

# Si el archivo declara un conteo que ya no es cierto, hay que enterarse.
printf -- '---\ntema: x\ncaracteres: 999\n---\nhola\n' > "$caja/miente.md"
aviso=$(./config/contar.sh "$caja/miente.md" 2>&1 >/dev/null | grep -c 'declara')
comprobar "avisa si el caracteres: declarado no cuadra" "1" "$aviso"

printf -- '---\ntema: x\ncaracteres: 4\n---\nhola\n' > "$caja/cuadra.md"
aviso=$(./config/contar.sh "$caja/cuadra.md" 2>&1 >/dev/null | grep -c 'declara')
comprobar "no avisa si cuadra" "0" "$aviso"

echo "== estado.sh =="
# estado.sh siempre opera sobre su propio repo, así que se prueba sobre una copia.
copia="$caja/repo"; mkdir -p "$copia"
cp -r config "$copia/"; mkdir -p "$copia"/workspace/{00-bitacora/corridas,01-investigacion,02-temas,03-borradores,04-revisiones,05-publicados}
touch "$copia/workspace/00-bitacora/registro.md"

post "$copia/workspace/03-borradores/2026-01-01-tema-a.md" "hola"
for n in "" "-2" "-3"; do
  ver=$([ "$n" = "-3" ] && echo RECHAZADO || echo "APROBADO CON CAMBIOS")
  printf -- '---\nveredicto: %s\n---\n' "$ver" > "$copia/workspace/04-revisiones/2026-01-01-tema-a.revision$n.md"
done
# mtime futura en la revisión MÁS VIEJA: ordenar por fecha de modificación se equivoca.
touch -d '2030-01-01' "$copia/workspace/04-revisiones/2026-01-01-tema-a.revision.md"
post "$copia/workspace/03-borradores/2026-01-02-tema-b.md" "hola"

salida=$("$copia/config/estado.sh" 2>/dev/null)
comprobar "manda la revisión de número más alto, no la de mtime más nueva" \
  "1" "$(printf '%s' "$salida" | grep -c 'tema-a .*RECHAZADO (rev 3)')"
comprobar "un borrador sin revisión sale como SIN REVISAR" \
  "1" "$(printf '%s' "$salida" | grep -c 'tema-b .*SIN REVISAR')"
comprobar "ÚLTIMO ARTEFACTO usa el número de revisión" \
  "1" "$(printf '%s' "$salida" | grep -c 'revisiones .*revision-3.md')"

# Publicar es mover: el post sale de borradores y tiene que seguir apareciendo.
printf -- '---\ntema: x\nestado: publicado\npublicado: 2026-01-05\n---\nhola\n' \
  > "$copia/workspace/05-publicados/2026-01-01-tema-a.md"
rm "$copia/workspace/03-borradores/2026-01-01-tema-a.md"
salida=$("$copia/config/estado.sh" 2>/dev/null)
comprobar "lo publicado aparece en su sección tras moverlo" \
  "1" "$(printf '%s' "$salida" | grep -A2 'PUBLICADOS' | grep -c 'tema-a .*2026-01-05')"
comprobar "y ya no figura como pendiente" \
  "0" "$(printf '%s' "$salida" | sed -n '/BORRADORES/,/PUBLICADOS/p' | grep -c 'tema-a')"

echo "== gate de publicación =="
gate() { printf '%s' "$1" | "$copia/config/hooks/gate-publicacion.sh" >/dev/null 2>&1; echo $?; }
comprobar "deja pasar lo que no va a publicados" "0" \
  "$(gate '{"tool_name":"Write","tool_input":{"file_path":"workspace/03-borradores/2026-01-02-tema-b.md"}}')"
comprobar "deniega mover un post con veredicto RECHAZADO" "2" \
  "$(gate '{"tool_name":"Bash","tool_input":{"command":"mv workspace/03-borradores/2026-01-01-tema-a.md workspace/05-publicados/2026-01-01-tema-a.md"}}')"
comprobar "deniega publicar algo sin ninguna revisión" "2" \
  "$(gate '{"tool_name":"Write","tool_input":{"file_path":"workspace/05-publicados/2026-01-02-tema-b.md"}}')"
# Mencionar el directorio en un texto, un grep o un ls no es publicar: bloquear eso
# convierte el gate en ruido y empuja a desactivarlo.
comprobar "no bloquea un comando que solo nombra el directorio" "0" \
  "$(gate '{"tool_name":"Bash","tool_input":{"command":"grep -rn publicado workspace/05-publicados/ README.md"}}')"
comprobar "no bloquea leer un post ya publicado" "0" \
  "$(gate '{"tool_name":"Bash","tool_input":{"command":"cat workspace/05-publicados/2026-01-01-tema-a.md"}}')"

printf -- '---\nveredicto: APROBADO\n---\n' > "$copia/workspace/04-revisiones/2026-01-02-tema-b.revision.md"
comprobar "deja publicar con veredicto APROBADO" "0" \
  "$(gate '{"tool_name":"Write","tool_input":{"file_path":"workspace/05-publicados/2026-01-02-tema-b.md"}}')"

echo
echo "$ok correctas, $fallos fallidas"
[ "$fallos" -eq 0 ]
