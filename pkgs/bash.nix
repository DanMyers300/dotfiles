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

      function add_ssh_keys() {
        # Start the SSH agent if it's not already running
        eval "$(ssh-agent -s)" > /dev/null 2>&1

        # Loop through all the private keys in ~/.ssh
        for key in $(find ~/.ssh -type f -name "id_*" -not -name "*.pub"); do
            # Check if the key is already added to the SSH agent
            if ! ssh-add -l | grep -q "$(ssh-keygen -lf $key | awk '{print $2}')"; then
                ssh-add "$key"
            fi
        done
      }

      # Call the function to add SSH keys when the shell starts
      add_ssh_keys

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
