{
  inputs,
  config,
  unstable,
  pkgs,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    let

      cli = [
        git
        git-lfs
        xxd
        btop
        p7zip
        ripgrep
        bluez-tools
        dbus
        jq
        unzip
        openssl
      ];

      gui = [
        bitwarden-desktop
        pavucontrol
        baobab
        mullvad-vpn
        nerd-fonts.hack
        nerd-fonts.symbols-only
      ];

      games = [
        prismlauncher
        desmume
        mgba
        unstable.dolphin-emu
        r2modman
      ];

      zen = [ inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default ];

      hostProfiles = {
        nixstation = [
          gui
          games
          zen
          [ mpvpaper ]
          [ nvtopPackages.amd ]
          [
            qemu
            swtpm
          ]
          [ libreoffice ]
          [ cozy ]
          [ wireguard-tools ]
          [ gimp ]
          [ vlc ]
          [ signal-desktop ]
          [ pokemmo-installer ]
          [
            libimobiledevice
            usbmuxd
            ifuse
            altserver-linux
          ]
          [ xdg-utils ]
          [ unstable.claude-code ]
          [ chromium ]
          [ obs-studio ]
          [ obsidian ]
          [ opencode ]
          [ godot ]
          [ irssi ]
          [ grim slurp wl-clipboard ]
          [ wofi ]
          [ unstable.vintagestory ]
        ];
        nixtop = [
          [
            pulseaudio
            brightnessctl
          ]
        ];
        nixbook = [
          cli
          gui
          zen
          [ pokemmo-installer ]
          [ prismlauncher ]
          [ brightnessctl ]
          [ pulseaudio ]
          [ obsidian ]
          [ moonlight-qt ]
          [ claude-code ]
          [ opencode ]
          [ uxplay ]
          [ signal-desktop ]
          [ wofi ]
          [ grim slurp wl-clipboard ]
        ];
        nixserver = [ cli ];
      };

      hostPackages = cli ++ lib.concatLists (hostProfiles."${config.networking.hostName}" or [ ]);

    in
    hostPackages;
}
