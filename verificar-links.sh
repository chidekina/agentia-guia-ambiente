#!/usr/bin/env bash
# verificar-links.sh — os links internos deste guia apontam para algo que existe?
#
# Um guia de instalação apodrece: arquivo é renomeado, seção muda de título, e o
# link continua ali, mudo. O leitor clica, cai em nada, e conclui que o guia é
# desleixado — quando o conteúdo estava certo.
#
# Confere DUAS coisas por link relativo: o arquivo existe, e a âncora (#secao)
# corresponde a um título daquele arquivo.
#
# Não confere link http — isso exigiria rede, e um verificador que falha porque
# o wifi caiu treina todo mundo a ignorá-lo.
#
#   bash verificar-links.sh

set -uo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")" || exit 1

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  VERDE=$'\033[32m'; VERMELHO=$'\033[31m'; ZERO=$'\033[0m'
else
  VERDE=''; VERMELHO=''; ZERO=''
fi

falhas=0
total=0

# Converte um título markdown na âncora que o GitHub gera:
# minúscula, acento preservado, pontuação fora, espaço vira hífen.
ancora_de() {
  printf '%s' "$1" \
    | sed 's/^#\{1,6\}[[:space:]]*//' \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^[:alnum:][:space:]_-]//g' \
    | sed 's/[[:space:]]/-/g'   # 1:1, e NAO colapsando: o GitHub gera dois hifens para "— "
}

for arquivo in *.md; do
  # Extrai o alvo de cada [texto](alvo), um por linha.
  grep -o '\[[^]]*\]([^)]*)' "$arquivo" 2>/dev/null \
    | sed 's/.*(\(.*\))/\1/' \
    | while IFS= read -r alvo; do
        case "$alvo" in
          http*|mailto:*) continue ;;   # externo: fora do escopo, de propósito
        esac

        destino="${alvo%%#*}"
        frag="${alvo#*#}"
        [ "$frag" = "$alvo" ] && frag=""
        [ -z "$destino" ] && destino="$arquivo"   # link só de âncora, no próprio arquivo

        total=$((total + 1))

        if [ ! -f "$destino" ]; then
          printf '  %s✗%s %s → %s (arquivo não existe)\n' "$VERMELHO" "$ZERO" "$arquivo" "$alvo"
          falhas=$((falhas + 1))
          continue
        fi

        if [ -n "$frag" ]; then
          achou=0
          while IFS= read -r titulo; do
            [ "$(ancora_de "$titulo")" = "$frag" ] && { achou=1; break; }
          done < <(grep '^#\{1,6\}[[:space:]]' "$destino")

          if [ "$achou" -eq 0 ]; then
            printf '  %s✗%s %s → %s (âncora não existe em %s)\n' \
              "$VERMELHO" "$ZERO" "$arquivo" "$alvo" "$destino"
            falhas=$((falhas + 1))
            continue
          fi
        fi

        printf '  %s✓%s %s → %s\n' "$VERDE" "$ZERO" "$arquivo" "$alvo"
      done
done > /tmp/verificar-links.$$ 2>&1

cat /tmp/verificar-links.$$
falhas=$(grep -c '✗' /tmp/verificar-links.$$ || true)
total=$(grep -c '[✓✗]' /tmp/verificar-links.$$ || true)
rm -f /tmp/verificar-links.$$

printf '\n'
if [ "$total" -eq 0 ]; then
  printf '%sNENHUM link conferido — o verificador está cego, não o guia está limpo.%s\n' \
    "$VERMELHO" "$ZERO"
  exit 1
fi
if [ "$falhas" -eq 0 ]; then
  printf '%s%d de %d links internos ok.%s\n' "$VERDE" "$total" "$total" "$ZERO"
  exit 0
fi
printf '%s%d de %d links quebrados.%s\n' "$VERMELHO" "$falhas" "$total" "$ZERO"
exit 1
