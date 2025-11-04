#!/usr/bin/env bash
set -euo pipefail
mkdir -p home; echo '{ config, pkgs, ... }:{ home.packages = with pkgs; [ coreutils gnu-sed gawk findutils ]; }' > home/darwin.nix; echo '[write-home-darwin] OK'
