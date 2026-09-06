#!/usr/bin/env bash
# Cuenta los caracteres del cuerpo del post (lo que se pega en LinkedIn).
# Ignora el frontmatter YAML y todo lo que venga tras el separador '---' final.
set -euo pipefail

LIMITE="${LIMITE:-1200}"

# `wc -m` solo cuenta caracteres si el locale es UTF-8; con un locale C —o con uno
# que no esté instalado en esta máquina— cuenta bytes y cada tilde o ñ vale doble.
# Por eso no se fija un locale a ciegas: se prueban los candidatos hasta dar con
# uno que cuente 'ñ' (\303\261) como un solo carácter.
LOCALE_UTF8=""
for cand in "${LC_ALL:-}" "${LC_CTYPE:-}" "${LANG:-}" C.UTF-8 C.utf8 en_US.UTF-8 en_US.utf8; do
  [ -n "$cand" ] || continue
  if [ "$(printf '\303\261' | LC_ALL="$cand" wc -m 2>/dev/null | tr -d ' ')" = "1" ]; then
    LOCALE_UTF8="$cand"
    break
  fi
done
[ -n "$LOCALE_UTF8" ] ||
  echo "aviso: ningún locale UTF-8 disponible; se contarán bytes y las tildes valdrán doble" >&2

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

  n=$(printf '%s' "$cuerpo" | LC_ALL="$LOCALE_UTF8" wc -m | tr -d ' ')
  # el salto de línea que emite `head` no se ve en LinkedIn: fuera del conteo
  gancho=$(printf '%s' "$cuerpo" | head -n 1 | tr -d '\n' | LC_ALL="$LOCALE_UTF8" wc -m | tr -d ' ')

  if [ "$n" -le "$LIMITE" ]; then estado="OK"; else estado="EXCEDE por $((n - LIMITE))"; salida=1; fi
  printf '%-55s %5s/%s caracteres  [%s]  gancho: %s\n' "$f" "$n" "$LIMITE" "$estado" "$gancho"
done

exit $salida
