{
  inputs,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; let
    common = [
      git btop ghostty p7zip ripgrep
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
      libreoffice ungoogled-chromium
    ];

    # Define host -> package combinations
    hostProfiles = {
      nixstation = [games nvtop hyprland virtualization office];
      nixtop = [hyprland office];
    };

    hostPackages = lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    common ++ hostPackages;
}
