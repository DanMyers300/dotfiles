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
        thunar
      ];

      screenshot = [
        sway-contrib.grimshot
        grim
        slurp
        wl-clipboard
      ];

      zen = [ inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default ];
      dusklight = [ inputs.dusklight.packages."${pkgs.stdenv.hostPlatform.system}".default ];

      hostProfiles = {
        nixstation = [
          cli
          gui
          zen
          dusklight
          screenshot
          [
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
            usbmuxd
            ifuse
            altserver-linux
            xdg-utils
            chromium
            obs-studio
            obsidian
            opencode
            godot
            irssi
            wofi
            unstable.vintagestory
          ]
        ];
        nixbook = [
          cli
          gui
          zen
          screenshot
          [
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
