#!/usr/bin/env bash
# Gate de publicación: nada entra en el directorio de publicados sin un veredicto
# APROBADO del editor para ese mismo slug.
#
# Se engancha como PreToolUse sobre Bash|Write|Edit. Publicar es MOVER, así que la
# acción real es un `mv` por Bash: por eso se inspecciona también la línea de comando.
# Es un chequeo de cadena — atrapa el fallo realista (un agente que se equivoca), no a
# alguien que quiera esquivarlo a propósito.
#
# Contrato: lee el JSON del evento por stdin. Exit 0 = no opina. Exit 2 = deniega, y lo
# que salga por stderr se le devuelve al modelo como motivo.
set -uo pipefail

DESTINO="workspace/05-publicados"
raiz=$(cd "$(dirname "$0")/../.." && pwd)
entrada=$(cat)

ruta=$(printf '%s' "$entrada" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
comando=$(printf '%s' "$entrada" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if [ -n "$ruta" ]; then
  # Write/Edit: el destino es explícito y no hay ambigüedad posible.
  case "$ruta" in
    *"$DESTINO"*) objetivo="$ruta" ;;
    *) exit 0 ;;
  esac
elif [ -n "$comando" ]; then
  # Bash: solo interesa si además de nombrar el directorio hace algo que escriba en él.
  # Mencionarlo en un texto, un grep o un ls no es publicar, y bloquear eso sería ruido.
  case "$comando" in
    *"$DESTINO"*) ;;
    *) exit 0 ;;
  esac
  if printf '%s' "$comando" | grep -qE "(^|[;&|(]|[[:space:]])(mv|cp|install|rsync|ln|dd|tee)[[:space:]]" ||
     printf '%s' "$comando" | grep -qE ">>?[[:space:]]*[^[:space:]]*$DESTINO"; then
    objetivo="$comando"
  else
    exit 0
  fi
else
  exit 0
fi

# El slug es el nombre del .md que va a parar al directorio de publicados.
slug=$(printf '%s' "$objetivo" | tr ' "' '\n\n' | grep -o "$DESTINO/[^ ]*\.md" | head -1 | xargs -r basename 2>/dev/null)
slug="${slug%.md}"
if [ -z "$slug" ]; then
  echo "Gate de publicación: esta operación escribe en $DESTINO/ y no consigo identificar qué post es. Publica un archivo .md nombrado por su slug." >&2
  exit 2
fi

# Manda la revisión de número más alto, igual que en estado.sh.
rev=""; maxn=0
for r in "$raiz/workspace/04-revisiones/$slug".revision*.md; do
  [ -e "$r" ] || continue
  n=$(basename "$r" .md); n=${n##*.revision}; n=${n#-}
  case "$n" in ''|*[!0-9]*) n=1 ;; esac
  [ "$n" -ge "$maxn" ] && { maxn=$n; rev=$r; }
done

if [ -z "$rev" ]; then
  echo "Gate de publicación: '$slug' no tiene ninguna revisión en workspace/04-revisiones/. Tiene que pasar por editor-calidad antes de publicarse." >&2
  exit 2
fi

veredicto=$(awk -F': *' '/^veredicto:/{print $2; exit}' "$rev" | sed 's/[[:space:]]*$//')
if [ "$veredicto" != "APROBADO" ]; then
  echo "Gate de publicación: la revisión vigente de '$slug' ($(basename "$rev")) dice '${veredicto:-sin veredicto}', no APROBADO. Nada se publica sin veredicto APROBADO del editor." >&2
  exit 2
fi

exit 0
