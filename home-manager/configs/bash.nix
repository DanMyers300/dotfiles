{ ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''

      case $- in
      *i*) ;;
      *) return ;;
      esac

      HISTCONTROL=ignoreboth
      shopt -s histappend
      HISTSIZE=1000
      HISTFILESIZE=2000

      shopt -s checkwinsize

      parse_git_branch() {
          local branch
          branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
          local status=""
          [[ -n $(git status --porcelain 2>/dev/null) ]] && status="*"
          echo " ($branch$status)"
      }
      PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0;33m\]$(parse_git_branch)\[\e[0m\]\$ '

      PATH="$PATH:/opt/nvim-linux64/bin"
      PATH="$PATH:/home/dan/.local/bin"

      function add_ssh_keys() {
          eval "$(ssh-agent -s)" > /dev/null 2>&1
          # Exclude public keys, backups, known_hosts, and authorized_keys
          for key in $(find ~/.ssh -type f \
              -not -name "*.pub" \
              -not -name "known_hosts*" \
              -not -name "*.bak" \
              -not -name "authorized_keys"); do
              key_fingerprint=$(ssh-keygen -lf "$key" | awk '{print $2}')
              if ! ssh-add -l | grep -qF "$key_fingerprint"; then
                  ssh-add "$key" > /dev/null 2>&1
              fi
          done
      }
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

      # -- Alias Section --
      alias ai='opencode'
      alias enon='sudo tailscale set --exit-node=mullvad-exit'
      alias enonlan='sudo tailscale set --exit-node=mullvad-exit --exit-node-allow-lan-access'
      alias enoff='sudo tailscale set --exit-node='
    '';
  };
}
