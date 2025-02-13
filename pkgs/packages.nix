{
  inputs,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; let

    minimal = [
      git btop p7zip ripgrep fastfetch
    ];

    common = [
      vesktop bitwarden-desktop pavucontrol
      bluez-tools baobab mullvad-vpn
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
      nixstation = [common games nvtop chrome hyprland virtualization office];
      nixtop = [common hyprland chrome office];
    };

    hostPackages = lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    minimal ++ hostPackages;
}
