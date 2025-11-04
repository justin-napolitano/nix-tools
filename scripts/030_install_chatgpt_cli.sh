#!/usr/bin/env bash
set -euo pipefail
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$PWD/.npm-global}"
mkdir -p "$NPM_CONFIG_PREFIX"
command -v npm >/dev/null 2>&1 || { echo "Run inside 'nix develop'"; exit 1; }
npm install -g chatgpt-cli
echo "[chatgpt-cli] OK"
