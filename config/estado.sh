#!/usr/bin/env bash
# Estado del pipeline: qué hay en cada etapa y qué está atascado.
set -uo pipefail
cd "$(dirname "$0")/.."

# El "último" artefacto sale del nombre (prefijo de fecha, y sufijo de revisión
# cuando lo hay), no de la mtime: tras un clon todos los archivos comparten mtime.
ult() { ls -1 "$1"/*.md 2>/dev/null | grep -v '/\.' | sort -V | tail -1; }

echo "=== ETAPAS ==="
printf '%-16s %-46s %s\n' "ETAPA" "ÚLTIMO ARTEFACTO" "TOTAL"
for e in 01-investigacion:investigacion 02-temas:temas 03-borradores:borradores \
         04-revisiones:revisiones 05-publicados:publicados; do
  d="workspace/${e%%:*}"; n=$(ls -1 "$d"/*.md 2>/dev/null | wc -l | tr -d ' ')
  printf '%-16s %-46s %s\n' "${e##*:}" "$(basename "$(ult "$d")" 2>/dev/null || echo '—')" "$n"
done

echo
echo "=== BORRADORES (pendientes) ==="
pend=0
for f in workspace/03-borradores/*.md; do
  [ -e "$f" ] || { echo "(ninguno)"; break; }
  slug=$(basename "$f" .md)
  # Puede haber varias revisiones del mismo borrador: manda la de número más alto.
  # No sirve ordenar por fecha de modificación: tras un clon todas comparten mtime.
  rev=""; nrev=0; maxn=0
  for r in "workspace/04-revisiones/$slug".revision*.md; do
    [ -e "$r" ] || continue
    nrev=$((nrev+1))
    n=$(basename "$r" .md); n=${n##*.revision}; n=${n#-}   # ".revision-2" -> "2"
    case "$n" in ''|*[!0-9]*) n=1 ;; esac                  # ".revision" -> 1
    [ "$n" -ge "$maxn" ] && { maxn=$n; rev=$r; }
  done
  chars=$(./config/contar.sh "$f" 2>/dev/null | awk '{print $2}')
  if [ -n "$rev" ]; then
    v=$(awk -F': *' '/^veredicto:/{print $2; exit}' "$rev")
  else
    v="SIN REVISAR"; pend=$((pend+1))
  fi
  # el veredicto crudo manda las pistas de abajo; el sufijo es solo para mostrar
  etiqueta="$v"; [ "$nrev" -gt 1 ] && etiqueta="$v (rev $maxn)"
  printf '  %-46s %-12s %s\n' "$slug" "$chars" "$etiqueta"
  case "$v" in
    # publicar es mover: lo que sigue en 03-borradores/ es, por definición, lo pendiente
    APROBADO) echo "     ↳ listo para publicar, esperando al humano" ;;
    RECHAZADO) echo "     ↳ devolver al redactor" ;;
    "APROBADO CON CAMBIOS") echo "     ↳ hay cambios propuestos sin aplicar" ;;
    "SIN REVISAR") echo "     ↳ falta pasar editor-calidad" ;;
  esac
done

echo
echo "=== PUBLICADOS ==="
for f in workspace/05-publicados/*.md; do
  [ -e "$f" ] || { echo "(ninguno)"; break; }
  slug=$(basename "$f" .md)
  fecha=$(awk -F': *' '/^publicado:/{print $2; exit}' "$f")
  printf '  %-46s %s\n' "$slug" "${fecha:-sin fecha de publicación}"
done

echo
echo "=== BITÁCORA ==="
c=$(ls -1 workspace/00-bitacora/corridas/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  corridas registradas: $c"
[ -f workspace/00-bitacora/registro.md ] || echo "  ⚠ falta workspace/00-bitacora/registro.md"
[ "$pend" -gt 0 ] && echo "  ⚠ $pend borrador(es) sin revisar"
exit 0
