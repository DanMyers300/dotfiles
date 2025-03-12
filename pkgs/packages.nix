{
  inputs,
  config,
  unstable,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; let

    minimal = [
      git git-lfs xxd btop p7zip ripgrep fastfetch
    ];

    common = [
      vesktop bitwarden-desktop pavucontrol
      bluez-tools baobab mullvad-vpn
    ];

    hyprland = [
      wl-clipboard nerdfonts sway-contrib.grimshot wofi
      ];

    games = [
      r2modman prismlauncher
      linuxKernel.packages.linux_zen.xpadneo
    ];

    rain = [ inputs.rain-mixer.packages.${system}.default ];

    hostProfiles = {
      nixstation = [
        common rain games [nvtopPackages.amd]
        [ungoogled-chromium] hyprland
        [qemu swtpm] [libreoffice]
        [rpcs3] [firefox]
      ];
      nixtop = [common hyprland [ungoogled-chromium] [libreoffice]];
    };

    hostPackages = lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    minimal ++ hostPackages;
}
