#!/usr/bin/env bash
set -euo pipefail
USER_NAME="${USER:-$(id -un)}"; UNAME_S="$(uname -s)"; UNAME_M="$(uname -m)"
case "${UNAME_S}_${UNAME_M}" in
  Linux_x86_64|Linux_aarch64)  HM_TARGET="${USER_NAME}@linux"  ;; 
  Darwin_x86_64|Darwin_arm64)  HM_TARGET="${USER_NAME}@darwin" ;; 
  *) echo "Unsupported platform"; exit 1;; 
esac
[[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix run home-manager/master -- switch --flake ".#${HM_TARGET}"
echo "[hm-apply] OK"
