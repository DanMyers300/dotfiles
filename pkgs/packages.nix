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
    ];

    gui = [
      bitwarden-desktop pavucontrol
      baobab mullvad-vpn
    ];

    hyprland = [
      wl-clipboard nerdfonts sway-contrib.grimshot wofi
      ];

    gamecontroller = [
      linuxKernel.packages.linux_zen.xpadneo
    ];

    rain = [ inputs.rain-mixer.packages."${system}".default ];

    zen = [ inputs.zen-browser.packages."${system}".default ];

    hostProfiles = {
      nixstation = [
        gui rain gamecontroller zen hyprland
        [ungoogled-chromium] [nvtopPackages.amd]
        [qemu swtpm] [libreoffice] [gimp] [cozy]
      ];
      nixtop = [ gui hyprland ] [ remmina ];
    };

    hostPackages = cli ++ lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    hostPackages;
}
