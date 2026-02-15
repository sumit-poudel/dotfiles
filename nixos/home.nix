{ config, pkgs, inputs, ... }:

{
  home.username = "sumit";
  home.homeDirectory = "/home/sumit";
  home.stateVersion = "25.11"; 

  # --- BASH CONFIGURATION ---
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos btw";
    };
  };

  # --- HELPER PROGRAMS ---
  programs.zoxide.enable = true;
  programs.starship.enable = true;

  # --- ZSH CONFIGURATION ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "node" "npm" ];
    };
   
   plugins = [
    {
      name = "zsh-vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }
  ];

    initContent = ''
      # Fastfetch ASCII header
      if command -v fastfetch >/dev/null; then
        cat <<'SUMIT'
                  _ __
   ___ __ ____ _  (_) /_
  (_-</ // / ' \/ / __/
 /___/\_,_/_/_/_/_/\__/
SUMIT
        fastfetch
      fi

      # Vim mode and Initialization
      bindkey -v
      eval "$(pay-respects zsh)"
    '';

    shellAliases = {
      # Navigation & General
      src = "source ~/.zshrc";
      esrc = "nvim /etc/nixos/home.nix"; 
      fk = "respect"; # The pay-respects command
      diff = "icdiff";
      py = "python";
      vi = "nvim";

      # Eza (Better ls)
      ls = "eza -a --color=always --group-directories-first --icons";
      la = "eza -l --color=always --group-directories-first --icons";
      lsa = "eza -al --color=always --group-directories-first --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";

      # Networking & System
      pg = "ping -c 5 google.com";
      update = "sudo nixos-rebuild switch";
      plz = "sudo";

      # Nix Package Management (Replacing Pacman/Paru)
      yeet = "nh os drop"; 
      pkgs = "nh search";  
      pkgu = "sudo nixos-rebuild switch --upgrade";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  # --- ENVIRONMENT VARIABLES ---
  home.sessionVariables = {
    BUN_INSTALL = "$HOME/.bun";
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.npm-global/bin"
  ];

  # --- USER PACKAGES ---
  home.packages = with pkgs; [
    # Terminal Essentials
    fastfetch
    nodejs_22
    bun
    starship
    zoxide
    eza
    pay-respects
    icdiff
    bat
    nh           # Required for your 'yeet' and 'pkgs' aliases
    # Applications
    brave
    # Development (Optional: uncomment if needed)
    # nodejs
    # python3
    # neovim
  ];
}
