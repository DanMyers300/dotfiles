{
  inputs,
  lib,
  config,
  pkgs,
  unstable,
  ...
}:
{

  imports = [
    ./common.nix
    ./hardware/nixstation-hardware.nix
    ../pkgs/packages.nix
    ../pkgs/steam.nix
    ../pkgs/stylix.nix
    ../pkgs/bootloader.nix
    ../pkgs/xserver.nix
    ../pkgs/sway.nix
    ../pkgs/gnome.nix
    ../pkgs/docker.nix
    ../pkgs/virt.nix
    ../pkgs/tailscale.nix
    ../pkgs/vpn.nix
    ../pkgs/sunshine.nix
    ../pkgs/gameController.nix
  ];

  ### --- Networking --- ###
  networking = {
    networkmanager.enable = true;
    hostName = "nixstation";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3000 47990 5984 42420 ];
      allowedUDPPorts = [ 42420 ];
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  programs.nix-ld.enable = true;

  ### --- Version --- ###
  system.stateVersion = "25.11";
}
