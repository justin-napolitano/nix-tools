#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/.config/nix"
NIX_CONF="$HOME/.config/nix/nix.conf"
grep -q "experimental-features" "$NIX_CONF" 2>/dev/null || echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
echo "[enable-flakes] OK"
