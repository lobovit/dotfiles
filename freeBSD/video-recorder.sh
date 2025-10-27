#!/usr/bin/env bash
# generate.sh — grava a janela do Emacs com wf-recorder
# Uso: ./generate.sh output.mp4

# Verifica se foi passado um argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <arquivo-de-saida.mp4>"
  exit 1
fi

OUTPUT="$1"

# Captura a região da janela do Emacs usando swaymsg e jq
GEOMETRY=$(swaymsg -t get_tree | jq -r '
  ..
  | select(.type? and (.type=="con" or .type=="floating_con"))
  | select(
      (.app_id? and (.app_id=="emacs" or .app_id=="emacs-gtk"))
      or (.window_properties?.class? == "Emacs")
      or (.name? and (.name | test("(?i)\\bemacs\\b")))
    )
  | .rect
  | "\(.x),\(.y) \(.width)x\(.height)"
  ' | head -n1)

# Se não encontrar a janela do Emacs, aborta
if [ -z "$GEOMETRY" ]; then
  echo "Nenhuma janela do Emacs encontrada."
  exit 1
fi

echo "Gravando janela do Emacs com wf-recorder..."
echo "Região detectada: $GEOMETRY"
echo "Saída: $OUTPUT"

# Executa o wf-recorder
wf-recorder -g "$GEOMETRY" -f "$OUTPUT"
