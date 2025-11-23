{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  ########################################
  # Zsh + Powerlevel10k Configuration
  ########################################
  programs.zsh = {
    enable = true;

    # Run before OMZ/theme loads — critical for disabling the wizard.
    initExtraFirst = ''
      # Prevent Powerlevel10k wizard from ever launching
      export POWERLEVEL10K_DISABLE_CONFIGURATION_WIZARD=true
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

      # p10k instant prompt (this is what the wizard would add at the very top)
      [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-${(%):-%n}.zsh" ]] \
        && source "${config.xdg.cacheHome}/p10k-instant-prompt-${(%):-%n}.zsh"

      # Load your saved Powerlevel10k configuration before the theme
      [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # Manually load the Powerlevel10k theme AFTER config and env vars are ready
      source ${pkgs.zsh-powerlevel10k}/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    '';

    oh-my-zsh = {
      enable = true;
      theme = null; # prevent OMZ from autoloading p10k too early
      plugins = [
        "git"
        "fzf"
        "z"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
    };

    initExtra = ''
      # Load API keys if present
      [[ -f "$HOME/.openai_api_key" ]] && source "$HOME/.openai_api_key"

      # FZF defaults
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
      #python utils
      export PATH="$HOME/.local/bin:$PATH"
      # Common aliases
      alias ls='eza -al --group-directories-first' 2>/dev/null || alias ls='ls -al'
      alias cat='bat' 2>/dev/null || true
      alias nd='nix develop -c zsh'
      alias ll='ls -al'

      # Initialize zoxide
      eval "$(zoxide init zsh)"
    '';

    # Declarative pipx + packages
    programs.pipx = {
      enable = true;
      packages = [
        "aider-chat"
      ];
    };
  };

  ########################################
  # Powerlevel10k Config (read-only, declarative)
  ########################################
  home.file.".p10k.zsh".source = ./dotfiles/p10k.zsh;

  ########################################
  # Session Variables (exported before shell init)
  ########################################
  home.sessionVariables = {
    POWERLEVEL10K_DISABLE_CONFIGURATION_WIZARD = "true";
    POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD  = "true";
  };

  ########################################
  # Common CLI Tools
  ########################################
  home.packages = with pkgs; [
    zsh-powerlevel10k
    eza
    bat
    fd
    ripgrep
    fzf
    neovim
    tree
    gh
    jq
    curl
    wget
    httpie
    unzip
    htop
    tmux
    lazygit
  ];

  ########################################
  # Additional Program Config
  ########################################
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = false;
  programs.git.enable = true;
}

