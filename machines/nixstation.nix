{
  inputs,
  lib,
  config,
  pkgs,
  unstable,
  ...
}:
let
  greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
    output HDMI-A-2 disable
    output DP-2 disable
    exec "${pkgs.regreet}/bin/regreet; swaymsg exit"
  '';
in
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
    ../pkgs/regreet.nix
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

  ### --- User setup --- ###
  users.users.dan.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEVdbTZeHyd3Hy5Yz1eQWKg+4xhKt3blqFLjjrgtnsH dan@nixtop"
  ];

  programs.nix-ld.enable = true;

  ### --- Greeter --- ###
  services.greetd.settings.default_session.command = lib.mkForce
    "${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --config ${greetdSwayConfig}";

  ### --- Version --- ###
  system.stateVersion = "25.11";
}
