#!/usr/bin/env bash
set -euo pipefail
[[ -f .envrc ]] || echo 'use flake' > .envrc; echo '[envrc] OK'
