+++
title = "Nix Workstation: Declarative Dev Environment with Nix Flakes & Home Manager"
description = "Set up a fully reproducible dev environment using Nix flakes, Home Manager, and tools like Zsh, Neovim, Node, Python, and ChatGPT CLI."
tags = [
    "nix",
    "home manager",
    "nix flakes",
    "zsh",
    "neovim",
    "nodejs",
    "python",
    "chatgpt",
    "dev environment",
    "declarative",
]
date = "2025-11-04T13:28:58-05:00"
categories = [
    "Development",
    "DevOps",
    "Nix",
]
series = []

[extra]
lang = "en"
toc = true
comment = false
copy = true
#outdate_alert = false
#outdate_alert_days = 120
math = false
mermaid = false
featured = true
reaction = false
+++

# 🧩 Nix Workstation — Cobra’s Declarative Dev Environment

A fully reproducible workstation built with **Nix flakes** and **Home Manager**.  
Features:
- Zsh + Oh-My-Zsh + Powerlevel10k
- Autosuggestions & Syntax Highlighting
- Neovim with lazy.nvim, Treesitter, and LSPs
- Dev tools (Git, Bat, Eza, Fd, Ripgrep, Fzf, Tmux, Lazygit, etc.)
- Node 22, Python 3.12, Prettier, Terraform, Docker, AWS CLI
- ChatGPT CLI alias (`chat`) via `npx`
- Direnv + Flakes + Home Manager integration

---

## 🚀 Quick Start on a New Machine

1. **Install Nix**
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --no-daemon
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. **Clone this repo**
   ```bash
   git clone https://github.com/YOURUSERNAME/nix-tools.git
   cd nix-tools
   ```

3. **Activate Home Manager**
   ```bash
   nix run home-manager/master -- switch --flake .#cobra@linux
   ```

4. **Start your new shell**
   ```bash
   exec zsh
   ```
   Powerlevel10k will open its first-time setup wizard.

---

## 🧠 Development Shell

Enter your pinned dev environment:
```bash
nix develop
```

Inside you’ll find:
- Node 22, npm, and pip
- Language servers (TypeScript, Python, Bash, Lua, YAML)
- Terraform, kubectl, AWS CLI
- Aliases and OMZ prompt
- `chat` alias for ChatGPT CLI (via `npx`)

To leave the shell:
```bash
exit
```

---

## 🔑 OpenAI API Key

Create a private key file (do **not** commit this):
```bash
echo 'export OPENAI_API_KEY="sk-...your-key..."' > ~/.openai_api_key
echo 'export TOKEN="$OPENAI_API_KEY"' >> ~/.openai_api_key
chmod 600 ~/.openai_api_key
```

Reload your shell:
```bash
exec zsh
```

Test ChatGPT:
```bash
chat "Write a Nix expression that prints hello world"
```

---

## ⚙️ Maintenance

**Update all inputs (nixpkgs + Home Manager):**
```bash
nix flake update
git add flake.lock
git commit -m "update nixpkgs + home-manager"
```

**Re-apply configuration:**
```bash
nix run home-manager/master -- switch --flake .#cobra@linux
```

---

## 🧹 Troubleshooting

| Issue | Fix |
|-------|-----|
| `powerlevel10k not found` | Run `make link-p10k` or re-apply HM |
| `direnv conflict` | Remove old profile installs: `nix profile remove direnv nix-direnv` |
| `terraform unfree error` | `allowUnfree = true` already set in flake |
| ChatGPT CLI says `TOKEN` missing | Ensure both `OPENAI_API_KEY` and `TOKEN` are exported |

---

## 💡 Tips

- `nd` alias → opens zsh in dev shell (`nix develop -c zsh`)
- `nix fmt` → formats your flake
- `nix flake show` → inspect available outputs
- `home-manager news` → view Home Manager changelog

---

## 🧰 Stack Summary

| Component | Managed by | Notes |
|------------|-------------|-------|
| Shell | Home Manager | Zsh + OMZ + p10k |
| Editor | Home Manager | Neovim (lazy.nvim + LSPs) |
| CLIs | Home Manager | Git, Eza, Bat, Fzf, Ripgrep, etc. |
| Languages | DevShell | Node 22, Python 3.12 |
| AI | Alias | `chat` → ChatGPT CLI |
| Config | Flake | One file (`flake.nix`) = entire setup |

---

### 🔒 Reproducibility
Everything except your API key is declarative.  
To recreate this environment anywhere:

```bash
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
git clone https://github.com/YOURUSERNAME/nix-tools.git
cd nix-tools
nix run home-manager/master -- switch --flake .#cobra@linux
exec zsh
```

Enjoy your reproducible dev environment ⚙️💀
