{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  programs.bash = {
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
      #if [ -z "$TMUX" ]; then
      #  if tmux has-session 2>/dev/null; then
      #    :
      #  else
      #    exec tmux new-session
      #  fi
      #fi

      function bt_toggle() {
          local mac_address="90:62:3F:4F:28:B5"
          if bluetoothctl info "$mac_address" | grep -q "Connected: yes"; then
              bluetoothctl disconnect "$mac_address"
              echo "Disconnected from $mac_address"
          else
              bluetoothctl connect "$mac_address"
              echo "Connected to $mac_address"
          fi
      }
      alias airpods='bt_toggle'

      # Alias Section
      # -- configs -- #
      alias hm='home-manager switch --flake /home/dan/dotfiles/#dan'
      alias nixstation='sudo nixos-rebuild switch --flake /home/dan/dotfiles/#nixstation'

      # -- Vim -- #
      alias vim='nvim'
      alias vi='nvim'
      alias v='nvim'
      
      '';
  };
}
