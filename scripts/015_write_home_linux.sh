#!/usr/bin/env bash
set -euo pipefail
mkdir -p home; echo '{ config, pkgs, ... }:{ programs.zsh.enable = true; home.packages = with pkgs; [ ]; }' > home/linux.nix; echo '[write-home-linux] OK'
