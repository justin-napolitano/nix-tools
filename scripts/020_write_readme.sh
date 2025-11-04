#!/usr/bin/env bash
set -euo pipefail
cat > README.md <<'R'
# Nix workstation (Make-driven)

```
make bootstrap
# new terminal
nix develop
make install-chatgpt
```
R
echo '[readme] OK'
