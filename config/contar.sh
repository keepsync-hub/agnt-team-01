#!/usr/bin/env bash
# Cuenta los caracteres del cuerpo del post (lo que se pega en LinkedIn).
# Ignora el frontmatter YAML y todo lo que venga tras el separador '---' final.
set -euo pipefail

LIMITE="${LIMITE:-1200}"

if [ $# -eq 0 ]; then
  echo "uso: $0 <archivo.md> [archivo2.md ...]" >&2
  exit 2
fi

salida=0
for f in "$@"; do
  [ -f "$f" ] || { echo "no existe: $f" >&2; salida=1; continue; }

  cuerpo=$(awk '
    BEGIN { sep = 0; dentro = 0 }
    /^---[[:space:]]*$/ {
      sep++
      if (NR == 1)      { next }        # abre frontmatter
      if (sep == 2)     { dentro = 1; next }  # cierra frontmatter -> empieza cuerpo
      if (dentro == 1)  { exit }        # separador de notas -> termina cuerpo
      next
    }
    NR == 1 && $0 !~ /^---/ { dentro = 1 }   # archivo sin frontmatter
    dentro { print }
  ' "$f")

  # recorta líneas en blanco al inicio y al final
  cuerpo=$(printf '%s' "$cuerpo" | sed -e '/./,$!d' | awk 'BEGIN{RS="\0"} {sub(/\n+$/,""); print}')

  n=$(printf '%s' "$cuerpo" | LC_ALL=en_US.UTF-8 wc -m | tr -d ' ')
  gancho=$(printf '%s' "$cuerpo" | head -n 1 | LC_ALL=en_US.UTF-8 wc -m | tr -d ' ')

  if [ "$n" -le "$LIMITE" ]; then estado="OK"; else estado="EXCEDE por $((n - LIMITE))"; salida=1; fi
  printf '%-55s %5s/%s caracteres  [%s]  gancho: %s\n' "$f" "$n" "$LIMITE" "$estado" "$gancho"
done

exit $salida
