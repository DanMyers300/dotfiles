{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./hardware/nixserver-hardware.nix
    ../pkgs/packages.nix
  ];

  ### --- Boot loader --- ###
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
  };
  boot.loader.systemd-boot.enable = false;

  ### --- Networking --- ###
  networking = {
    hostName = "nixserver";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  ### --- Xserver setup --- ###
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  ### --- Virtualisation --- ###
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  ### --- Version --- ###
  system.stateVersion = "25.05";
}
