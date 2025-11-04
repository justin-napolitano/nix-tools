#!/usr/bin/env bash
set -euo pipefail
log(){ echo -e "\033[1;32m[nix-install]\033[0m $*"; }
err(){ echo -e "\033[1;31m[nix-install]\033[0m $*" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || err "curl not found."
if command -v nix >/dev/null 2>&1; then log "Nix already installed."; exit 0; fi
sh <(curl -fsSL https://nixos.org/nix/install) --no-daemon
[[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
log "Nix installed."
