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

      rain = [ inputs.rain-mixer.packages."${system}".default ];

      zen = [ inputs.zen-browser.packages."${system}".default ];

      csharp = [
        dotnet-sdk_9
      ];

      hostProfiles = {
        nixstation = [
          gui
          rain
          games
          zen
          hyprland
          csharp
          #[ungoogled-chromium]
          [ nvtopPackages.amd ]
          [ vesktop ]
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
          [ unstable.obsidian ]
        ];
        nixtop = [
          [
            pulseaudio
            brightnessctl
          ]
          gui
          zen
          hyprland
          [ openvpn ]
          [ pokemmo-installer ]
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
        ];
        nixserver = [ cli ];
      };

      hostPackages = cli ++ lib.concatLists (hostProfiles."${config.networking.hostName}" or [ ]);

    in
    hostPackages;
}
