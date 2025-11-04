{ config, pkgs, ... }:{ home.packages = with pkgs; [ coreutils gnu-sed gawk findutils ]; }
