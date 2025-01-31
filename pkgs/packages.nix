{
  inputs,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; let
    common = [
      git btop ghostty p7zip ripgrep vesktop
      bluez-tools baobab mullvad-vpn pavucontrol
    ];

    hyprland = [wl-clipboard nerdfonts sway-contrib.grimshot wofi];

    nvtop = [
      nvtopPackages.amd nvtopPackages.full
    ];

    games = [
      r2modman prismlauncher
      linuxKernel.packages.linux_zen.xpadneo
    ];

    virtualization = [qemu swtpm];
    
    office = [
      libreoffice
    ];

    chrome = [ ungoogled-chromium ];

    #--- HOSTS ---#
    hostProfiles = {
      nixstation = [games nvtop chrome hyprland virtualization office];
      nixtop = [hyprland chrome office];
      nixvm = [chrome];
    };

    hostPackages = lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    common ++ hostPackages;
}
