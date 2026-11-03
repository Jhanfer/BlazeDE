#!/usr/bin/env bash
# rutash - imprime una frase aleatoria (usa archivo ~/.config/rutash/phrases.txt si existe)

# Ruta al archivo de frases (una frase por línea)
PHRASES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/rutash/phrases.txt"

DEFAULT_PHRASES=(
  "Las mieldas city."
  "Fortnite..."
  "Ivana, si lees eesto: CITY!!"
  "Half-Life 3 confirmed."
  "¿Por qué los pájaros no usan Facebook? Porque ya tienen Twitter."
  "Las mieldas city es el mejor lugar del mundo."
  "'Me considero Dalista.' - Algún gilipollas."
  "Ña"
  "I wans't lookin' for love this year... "
  "Hello, Clancy."
)

# Función: escoger una línea aleatoria desde stdin (awk fallback)
pick_with_awk() {
  awk 'BEGIN { srand(systime() + PROCINFO["pid"]); }
      { a[NR] = $0 }
      END { if (NR>0) print a[int(rand()*NR)+1] }'
}

# Si existe archivo de frases y no está vacío, úsalo; si no, usa DEFAULT_PHRASES
if [ -f "$PHRASES_FILE" ] && [ -s "$PHRASES_FILE" ]; then
  # Intentar usar shuf si está disponible, si no usar awk
  if command -v shuf >/dev/null 2>&1; then
    shuf -n1 "$PHRASES_FILE"
  else
    # Leer archivo y pasar a awk
    sed -n '1,${p;}' "$PHRASES_FILE" | pick_with_awk
  fi
else
  # Imprimir una de las frases por defecto
  if command -v shuf >/dev/null 2>&1; then
    printf "%s\n" "${DEFAULT_PHRASES[@]}" | shuf -n1
  else
    printf "%s\n" "${DEFAULT_PHRASES[@]}" | pick_with_awk
  fi
fi
