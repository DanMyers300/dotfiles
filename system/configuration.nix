{ 
  inputs,
  lib,
  config,
  pkgs,
  ... 
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./config/tmux.nix
      ./config/steam.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# Networking
  networking.hostName = "nixstation";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    #allowedTCPPorts = [ 80 443 ];
    #allowedUDPPortRanges = [
      #{ from = 4000; to = 4007; }
      #{ from = 8000; to = 8010; }
    #];
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.printing.enable = true;
  programs.firefox.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  
  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.variables.EDITOR = "nvim";

  services.mullvad-vpn.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  system.stateVersion = "24.05";
}
