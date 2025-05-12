{
  inputs,
  config,
  unstable,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; let

    cli = [
      git git-lfs xxd btop
      p7zip ripgrep bluez-tools
      dbus jq
    ];

    gui = [
      bitwarden-desktop pavucontrol
      baobab mullvad-vpn
    ];

    hyprland = [
      wl-clipboard nerdfonts sway-contrib.grimshot wofi
    ];

    games = [
      linuxKernel.packages.linux_zen.xpadneo
      prismlauncher desmume mgba
      dolphin-emu
    ];

    rain = [ inputs.rain-mixer.packages."${system}".default ];

    zen = [ inputs.zen-browser.packages."${system}".default ];

    hostProfiles = {
      nixstation = [
        gui rain games zen hyprland
        [ungoogled-chromium] [nvtopPackages.amd]
        [qemu swtpm] [libreoffice] [gimp] [cozy]
        [wireguard-tools] [tigervnc] [cargo]
        [gcc] [vesktop]
      ];
      nixtop = [ [pulseaudio brightnessctl] rain gui zen hyprland [openvpn] ];
    };

    hostPackages = cli ++ lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    hostPackages;
}
