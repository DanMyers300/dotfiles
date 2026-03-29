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
    ./hardware/nixbook-hardware.nix
    ../pkgs/packages.nix
    ../pkgs/steam.nix
    ../pkgs/stylix.nix
    ../pkgs/gnome.nix
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

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  ### --- Networking --- ###
  networking = {
    hostName = "nixbook";
    networkmanager.enable = true;
    firewall = {
      enable = false;
      checkReversePath = "loose";
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [
      ];
    };
  };

  ### --- Avahi (for UxPlay AirPlay server) --- ###
  ### --- Ports: TCP(7000 7001 7100) UDP: 5353 6000 6001 7011
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ### --- VPN --- ###
  services.mullvad-vpn.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  ### --- Broadcom insecure package --- ###
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.19.3"
  ];

  ### --- Docker --- ###
  virtualisation.docker.enable = true;

  ### --- User setup --- ###
  users.users.dan = {
    home = "/home/dan";
    extraGroups = [ "input" ];
  };

  system.stateVersion = "25.11";
}
