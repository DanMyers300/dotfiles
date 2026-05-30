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
    ../pkgs/bootloader.nix
    ../pkgs/packages.nix
    ../pkgs/stylix.nix
    ../pkgs/hypr.nix
    ../pkgs/xserver.nix
    ../pkgs/tailscale.nix
    ../pkgs/vpn.nix
    ../pkgs/avahi.nix
    ../pkgs/docker.nix
    ../pkgs/regreet.nix
  ];

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

  ### --- Networking --- ###
  networking = {
    hostName = "nixbook";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [
      ];
    };
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

  ### --- Broadcom insecure package --- ###
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-7.0.6"
  ];

  ### --- Lid switch --- ###
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };
}
