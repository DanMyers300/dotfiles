{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./common.nix
    ./hardware/nixtravel-hardware.nix
    ../pkgs/packages.nix
    ../pkgs/stylix.nix
  ];

  ### --- Boot loader --- ###
  boot.loader.systemd-boot.enable = true;

  ### --- Wifi drivers --- ###
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [
    "hid_apple"
    "kvm-intel"
    "wl"
  ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.broadcom_sta
  ];
  boot.kernelParams = [ "hid_apple.fnmode=2" ];

  ### --- Bluetooth --- ###
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  ### --- Networking --- ###
  networking.hostName = "nixtravel";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall.checkReversePath = "loose";

  services.openssh = {
    enable = false;
    ports = [ ];
    settings = {
      PasswordAuthentication = true;
      PubkeyAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      PermitRootLogin = "no";
    };
  };

  ### --- Xserver setup --- ###
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.sessionCommands = ''
      xhost +local:
    '';
  };

  ### --- Gnome --- ###
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;
  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-photos
      gnome-tour
      gedit # text editor
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]
  );

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ### --- VPN --- ###
  services.mullvad-vpn.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  ### --- Docker --- ###
  virtualisation.docker.enable = true;

  ### --- User setup --- ###
  users.users.dan = {
    home = "/home/dan";
    extraGroups = [ "input" ];
  };

  system.stateVersion = "25.11";
}
