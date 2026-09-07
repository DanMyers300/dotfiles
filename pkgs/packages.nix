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
        usbutils
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
        thunar
      ];

      screenshot = [
        sway-contrib.grimshot
        grim
        slurp
        wl-clipboard
      ];

      zen = [ inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default ];

      noctalia = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      hostProfiles = {
        nixstation = [
          cli
          gui
          zen
          noctalia
          screenshot
          [
            claude-code
            pulseaudio
            jdk25
            prismlauncher
            mpvpaper
            nvtopPackages.amd
            qemu
            swtpm
            libreoffice
            cozy
            wireguard-tools
            gimp
            vlc
            libaacs
            libbluray
            makemkv
            signal-desktop
            libimobiledevice
            ifuse
            altserver-linux
            xdg-utils
            chromium
            obs-studio
            obsidian
            godot
            irssi
            wofi
          ]
        ];
        nixbook = [
          cli
          gui
          zen
          noctalia
          screenshot
          [
            chromium
            claude-code
            brightnessctl
            pulseaudio
            obsidian
            moonlight-qt
            vlc
            uxplay
            signal-desktop
          ]
        ];
        nixserver = [ cli ];
        nixtop = [
          cli
          [
            pulseaudio
            brightnessctl
          ]
        ];
      };

      hostPackages = lib.concatLists (hostProfiles."${config.networking.hostName}" or [ ]);

    in
    hostPackages;
}
