{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  home.packages = with pkgs; [
    prismlauncher
    baobab
    qbittorrent
    vlc
    steam
    ollama
    signal-desktop
  ];

  programs = {

    alacritty = {
      enable = true;
      settings = {
        window = {
          title = "Nixstation";
          dynamic_title = false;
          opacity = lib.mkForce 0.8;
        };
      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        # If not running interactively, don't do anything
        case $- in
        *i*) ;;
        *) return ;;
        esac
        
        # History
        HISTCONTROL=ignoreboth
        shopt -s histappend
        HISTSIZE=1000
        HISTFILESIZE=2000
        
        # check the window size after each command and, if necessary,
        # update the values of LINES and COLUMNS.
        shopt -s checkwinsize
        
        # Path settings
        PATH="$PATH:/opt/nvim-linux64/bin"
        PATH="$PATH:/home/dan/.local/bin"
        
        # Easy SSH access
        alias danserver="ssh -X danserver@192.168.1.23"
        alias miniserver="ssh -X dan@192.168.1.16"
        
        # Enable tmux on startup
        if [ -z "$TMUX" ]; then
          if tmux has-session 2>/dev/null; then
            echo "There is already a tmux session. Running outside of tmux."
          else
            exec tmux new-session
          fi
        fi
        
        # Alias Section
        alias vim='nvim'
        alias vi='nvim'
        alias v='nvim'
        '';
    };

    home-manager.enable = true;
  };
}
