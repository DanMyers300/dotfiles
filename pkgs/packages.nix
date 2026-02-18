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

      hyprland = [
        wl-clipboard
        sway-contrib.grimshot
        wofi
      ];

      games = [
        prismlauncher
        desmume
        mgba
        unstable.dolphin-emu
        r2modman
      ];

      zen = [ inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default ];

      csharp = [
        dotnet-sdk_9
      ];

      hostProfiles = {
        nixstation = [
          gui
          games
          zen
          hyprland
          csharp
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
          [ via ]
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
          [ unstable.teamspeak6-client ]
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
          hyprland
          [ pokemmo-installer ]
          [ prismlauncher ]
          [ brightnessctl ]
          [ pulseaudio ]
          [ obsidian ]
          [ moonlight-qt ]
          [ claude-code ]
        ];
        nixserver = [ cli ];
      };

      hostPackages = cli ++ lib.concatLists (hostProfiles."${config.networking.hostName}" or [ ]);

    in
    hostPackages;
}
