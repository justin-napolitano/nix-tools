#!/usr/bin/env bash
set -euo pipefail

log(){ echo -e "\033[1;32m[add-home]\033[0m $*"; }
err(){ echo -e "\033[1;31m[add-home]\033[0m $*" >&2; exit 1; }

[[ -f flake.nix ]] || err "flake.nix not found in current directory."

USER_NAME="${USER:-$(id -un)}"
HOME_DIR="${HOME:-$(getent passwd "$USER_NAME" | cut -d: -f6 || echo)}"

UNAME_S="$(uname -s)"
UNAME_M="$(uname -m)"
case "${UNAME_S}_${UNAME_M}" in
  Linux_x86_64)   NIX_SYSTEM="x86_64-linux";   HM_TARGET="${USER_NAME}@linux"  ;;
  Linux_aarch64)  NIX_SYSTEM="aarch64-linux";  HM_TARGET="${USER_NAME}@linux"  ;;
  Darwin_x86_64)  NIX_SYSTEM="x86_64-darwin";  HM_TARGET="${USER_NAME}@darwin" ;;
  Darwin_arm64)   NIX_SYSTEM="aarch64-darwin"; HM_TARGET="${USER_NAME}@darwin" ;;
  *) err "Unsupported platform: ${UNAME_S}_${UNAME_M}";;
esac

# If already present, no-op
if grep -Fq "\"${HM_TARGET}\"" flake.nix; then
  log "homeConfigurations already contains ${HM_TARGET}"
  exit 0
fi

# Ensure the homeConfigurations block exists at all
if ! grep -Eq 'homeConfigurations[[:space:]]*=' flake.nix; then
  err "Did not find a 'homeConfigurations =' block in flake.nix."
fi

# Insert safely inside the block.
# Handles both:
#   homeConfigurations = { };
# and
#   homeConfigurations = {
#     ...
#   };
awk -v k="${HM_TARGET}" -v sysName="${NIX_SYSTEM}" -v userName="${USER_NAME}" -v homePath="${HOME_DIR}" '
  /homeConfigurations[[:space:]]*=[[:space:]]*\{/ {
    # If the opening line also closes the block (oneliner: "{ };")
    if ($0 ~ /\};[[:space:]]*$/) {
      # Remove the trailing "};"
      sub(/\};[[:space:]]*$/, "");
      print;
      print "      \"" k "\" = mkHomeCfg { system = \"" sysName "\"; username = \"" userName "\"; homeDir = \"" homePath "\"; };";
      print "    };";
      next
    } else {
      # Multiline block – insert right after the opening line
      print;
      print "      \"" k "\" = mkHomeCfg { system = \"" sysName "\"; username = \"" userName "\"; homeDir = \"" homePath "\"; };";
      next
    }
  }
  { print }
' flake.nix > flake.nix.tmp && mv flake.nix.tmp flake.nix

log "Added ${HM_TARGET} to homeConfigurations"

