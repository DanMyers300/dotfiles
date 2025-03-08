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

    nvtop = [
      nvtopPackages.amd
    ];

    games = [
      r2modman prismlauncher
      linuxKernel.packages.linux_zen.xpadneo
    ];

    virtualization = [qemu swtpm];
    
    office = [ libreoffice ];

    chrome = [ ungoogled-chromium ];

    ladyBird = with unstable; [ ladybird ];
  
    rain = [ inputs.rain-mixer.packages.${system}.default ];

    hostProfiles = {
      nixstation = [common rain games nvtop chrome ladyBird hyprland virtualization office];
      nixtop = [common hyprland];
    };

    hostPackages = lib.concatLists (hostProfiles."${config.networking.hostName}" or []);
    
  in
    minimal ++ hostPackages;
}
