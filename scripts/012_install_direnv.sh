#!/usr/bin/env bash
set -euo pipefail
if ! command -v direnv >/dev/null 2>&1; then nix profile install nixpkgs#direnv nixpkgs#nix-direnv; fi
[[ -f .envrc ]] || echo "use flake" > .envrc
direnv allow || true
echo "[direnv] OK"
