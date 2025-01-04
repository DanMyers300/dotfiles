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

      function airpods() {
          local mac_address="90:62:3F:4F:28:B5"
          if bluetoothctl info "$mac_address" | grep -q "Connected: yes"; then
              bluetoothctl disconnect "$mac_address"
              echo "Disconnected from $mac_address"
          else
              bluetoothctl connect "$mac_address"
              echo "Connected to $mac_address"
          fi
      }

      function proController() {
          local mac_address="E4:17:D8:C3:47:57"
          if bluetoothctl info "$mac_address" | grep -q "Connected: yes"; then
              bluetoothctl disconnect "$mac_address"
              echo "Disconnected from $mac_address"
          else
              bluetoothctl connect "$mac_address"
              echo "Connected to $mac_address"
          fi
      }
      '';
  };
}
