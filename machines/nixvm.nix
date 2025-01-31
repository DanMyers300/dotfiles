{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware/nixvm-hardware.nix
      ../pkgs/packages.nix
      ../pkgs/stylix.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  networking = {
    hostName = "nixvm";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      #allowedTCPPorts = [ 5173 ];
      #allowedUDPPortRanges = [
        #{ from = 5173; to = 5173; }
        #{ from = 8000; to = 8010; }
      #];
    };
  };
  
  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "24.11";

}

