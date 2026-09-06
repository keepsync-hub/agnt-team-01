#!/usr/bin/env bash
# Estado del pipeline: qué hay en cada etapa y qué está atascado.
set -uo pipefail
cd "$(dirname "$0")/.."

ult() { ls -1t "$1"/*.md 2>/dev/null | grep -v '/\.' | head -1; }

echo "=== ETAPAS ==="
printf '%-16s %-46s %s\n' "ETAPA" "ÚLTIMO ARTEFACTO" "TOTAL"
for e in 01-investigacion:investigacion 02-temas:temas 03-borradores:borradores \
         04-revisiones:revisiones 05-publicados:publicados; do
  d="workspace/${e%%:*}"; n=$(ls -1 "$d"/*.md 2>/dev/null | wc -l | tr -d ' ')
  printf '%-16s %-46s %s\n' "${e##*:}" "$(basename "$(ult "$d")" 2>/dev/null || echo '—')" "$n"
done

echo
echo "=== BORRADORES ==="
pend=0
for f in workspace/03-borradores/*.md; do
  [ -e "$f" ] || { echo "(ninguno)"; break; }
  slug=$(basename "$f" .md)
  # puede haber varias revisiones del mismo borrador: manda la más reciente
  rev=$(ls -t "workspace/04-revisiones/$slug".revision*.md 2>/dev/null | head -1)
  nrev=$(ls -1 "workspace/04-revisiones/$slug".revision*.md 2>/dev/null | wc -l | tr -d ' ')
  chars=$(./config/contar.sh "$f" 2>/dev/null | awk '{print $2}')
  if [ -n "$rev" ]; then
    v=$(awk -F': *' '/^veredicto:/{print $2; exit}' "$rev")
    [ "$nrev" -gt 1 ] && v="$v (rev $nrev)"
  else
    v="SIN REVISAR"; pend=$((pend+1))
  fi
  pub="no"; [ -f "workspace/05-publicados/$slug.md" ] && pub="sí"
  printf '  %-46s %-12s %-22s publicado: %s\n' "$slug" "$chars" "$v" "$pub"
  case "$v" in
    APROBADO|"APROBADO (rev "*) [ "$pub" = "no" ] && echo "     ↳ listo para publicar, esperando al humano" ;;
    RECHAZADO) echo "     ↳ devolver al redactor" ;;
    "APROBADO CON CAMBIOS") echo "     ↳ hay cambios propuestos sin aplicar" ;;
    "SIN REVISAR") echo "     ↳ falta pasar editor-calidad" ;;
  esac
done

echo
echo "=== BITÁCORA ==="
c=$(ls -1 workspace/00-bitacora/corridas/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  corridas registradas: $c"
[ -f workspace/00-bitacora/registro.md ] || echo "  ⚠ falta workspace/00-bitacora/registro.md"
[ "$pend" -gt 0 ] && echo "  ⚠ $pend borrador(es) sin revisar"
exit 0
