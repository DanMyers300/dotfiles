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

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  ### --- Wifi drivers --- ###
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [
    "hid_apple"
    "kvm-intel"
    "wl"
    "facetimehd"
  ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.broadcom_sta
    (config.boot.kernelPackages.facetimehd.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        sed -i '/wait_prepare/d; /wait_finish/d' fthd_v4l2.c
      '';
    }))
  ];
  boot.kernelParams = [ "hid_apple.fnmode=2" ];

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

  ### --- FaceTime HD camera firmware --- ###
  hardware.firmware = [ pkgs.facetimehd-firmware ];

  ### --- Broadcom insecure package --- ###
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.96"
    "electron-39.8.10"
  ];

  ### --- Lid switch --- ###
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };
}
