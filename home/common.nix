{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
      plugins = [ "git" "fzf" "z" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
    };
    initExtra = ''
      [[ -f "$HOME/.openai_api_key" ]] && source "$HOME/.openai_api_key"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
      alias ls='eza -al --group-directories-first' 2>/dev/null || alias ls='ls -al'
      alias cat='bat' 2>/dev/null || true
      eval "$(zoxide init zsh)"
    '';
    #autosuggestion.enable = true;
    #syntaxHighlighting.enable = true; 
    
    shellAliases = {
      nd = "nix develop -c zsh";
      ll = "ls -al";
      # add more aliases here
    };
  };
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = false;
  home.packages = with pkgs; [ zsh-powerlevel10k eza bat fd ripgrep fzf neovim tree gh jq curl wget httpie unzip htop tmux lazygit ];
  programs.git.enable = true;
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  home.sessionVariables = { EDITOR = "nvim"; };
}
