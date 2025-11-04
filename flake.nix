{
  description = "Simple, idiomatic Nix workstation: HM + devShell (zsh+p10k, nvim, CLIs)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    # ---- Core helpers --------------------------------------------------------
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;  # needed for terraform, etc.
    };

    mkHM = { system, username, homeDir }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        modules = [
          # ---- Home Manager config (inline) ----------------------------------
          ({ config, pkgs, ... }: {
            programs.home-manager.enable = true;
            home.username = username;
            home.homeDirectory = homeDir;
            home.stateVersion = "24.05";

            # ZSH + OMZ + p10k + plugins
            programs.zsh = {
              enable = true;

              # Make OMZ look in a writable custom path
              envExtra = ''
                export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
              '';

              oh-my-zsh = {
                enable = true;
                theme = "powerlevel10k/powerlevel10k";
                plugins = [ "git" "fzf" "z" ];
              };

              # New-style init (replaces deprecated initExtra)
              initContent = ''
                # Disable nvm inside nix shells (avoids prefix conflicts)
                if [[ -z "$IN_NIX_SHELL" ]]; then
                  export NVM_DIR="$HOME/.nvm"
                  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
                else
                  unset -f nvm 2>/dev/null || true
                  unset NVM_DIR
                fi

                # Environment & aliases
                if [[ -f "$HOME/.openai_api_key" ]]; then
                  source "$HOME/.openai_api_key"
                fi
                export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
                export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
                export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
                alias ls='eza -al --group-directories-first' 2>/dev/null || alias ls='ls -al'
                alias cat='bat' 2>/dev/null || true
                eval "$(zoxide init zsh)"

                # Handy: chat via npx (no global npm install needed)
                alias chat='npx -y chatgpt-cli@latest'
              '';

              # Let HM provide these (no OMZ copies needed)
              autosuggestion.enable = true;
              syntaxHighlighting.enable = true;
            };

            programs.fzf.enable = true;
            programs.zoxide.enable = true;
            programs.starship.enable = false; # p10k is the prompt

            # Install p10k package so we can link theme from the store
            home.packages = with pkgs; [
              zsh-powerlevel10k
              eza bat fd ripgrep fzf
              neovim tree
              gh jq curl wget httpie
              unzip htop
              tmux lazygit
            ];

            # Symlink the p10k theme into $HOME so OMZ can find it
            home.file.".oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme".source =
              "${pkgs.zsh-powerlevel10k}/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme";

            programs.git = {
              enable = true;
              userName = "YOUR_NAME";
              userEmail = "you@example.com";
              extraConfig = {
                init.defaultBranch = "main";
                pull.rebase = true;
                push.autoSetupRemote = true;
              };
            };

            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };

            home.sessionVariables = { EDITOR = "nvim"; };
          })
        ];
      };

    # DevShell for all systems
    mkShellFor = system:
      let pkgs = mkPkgs system; in
      pkgs.mkShell {
        packages = with pkgs; [
          bashInteractive gnumake coreutils gnused gawk findutils
          git curl wget jq unzip openssh
          neovim tmux lazygit
          eza bat fd ripgrep fzf tree httpie htop
          python312 python312Packages.pip
          nodejs_22 nodePackages.prettier
          nodePackages.typescript-language-server
          pyright bash-language-server
          lua-language-server yaml-language-server marksman
          shellcheck nixfmt-classic tree-sitter
          kubectl terraform awscli2
        ];

        shellHook = ''
          # Keep OMZ custom in $HOME (so themes/plugins are writable)
          export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

          # Disable nvm in nix shells (no global prefix fights)
          unset NVM_DIR
          unset -f nvm 2>/dev/null || true

          # Optional: load OpenAI key for the session
          if [ -f "$HOME/.openai_api_key" ]; then
            . "$HOME/.openai_api_key"
          fi
        
          # If we're in a real terminal and not already in zsh, jump into zsh
          if [ -t 1 ] && [ -z "''${ZSH_VERSION:-}" ]; then
            exec zsh
          fi

          echo "Dev shell ready"
          echo "node: $(node -v) | npm: $(npm -v) | python: $(python3 --version | awk '{print $2}')"
        '';
      };
  in
  {
    devShells = {
      x86_64-linux.default   = mkShellFor "x86_64-linux";
      aarch64-linux.default  = mkShellFor "aarch64-linux";
      x86_64-darwin.default  = mkShellFor "x86_64-darwin";
      aarch64-darwin.default = mkShellFor "aarch64-darwin";
    };

    # So `nix fmt` works
    formatter = (mkPkgs "x86_64-linux").nixfmt-classic;

    # Explicit Home Manager targets (no scripts needed)
    homeConfigurations = {
      "cobra@linux" = mkHM {
        system = "x86_64-linux";
        username = "cobra";
        homeDir = "/home/cobra";
      };
      # Add more machines as needed, e.g.:
      # "cobra@darwin" = mkHM { system = "aarch64-darwin"; username = "cobra"; homeDir = "/Users/cobra"; };
    };
  }
;
}

