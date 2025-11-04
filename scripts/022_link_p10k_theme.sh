#!/usr/bin/env bash
set -euo pipefail
log(){ echo -e "\033[1;32m[p10k-link]\033[0m $*"; }

# Ensure ZSH_CUSTOM points to a writable location (matches envExtra)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
TARGET_DIR="$ZSH_CUSTOM/themes/powerlevel10k"

# Resolve the theme file from nixpkgs
THEME_OUT="$(nix eval --raw nixpkgs#zsh-powerlevel10k.outPath)"
THEME_FILE="$(find "$THEME_OUT" -type f -name 'powerlevel10k.zsh-theme' | head -n1)"

if [[ -z "${THEME_FILE:-}" ]]; then
  echo "[p10k-link] Could not locate powerlevel10k.zsh-theme in $THEME_OUT" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
ln -sfn "$THEME_FILE" "$TARGET_DIR/powerlevel10k.zsh-theme"

log "Linked p10k at $TARGET_DIR/powerlevel10k.zsh-theme"

