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
    ../pkgs/hypr.nix
    ../pkgs/regreet.nix
    ../pkgs/docker.nix
    ../pkgs/virt.nix
    ../pkgs/tailscale.nix
    ../pkgs/vpn.nix
    ../pkgs/sunshine.nix
    ../pkgs/virtual-display.nix
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

  services.greetd.settings.initial_session = {
    command = "start-hyprland";
    user = "dan";
  };

  programs.nix-ld.enable = true;

  # The Realtek ALC897 has no jack detection, so all analog profiles report
  # 'not available' and WirePlumber defaults to 'off'. Force it to analog stereo
  # after WirePlumber enumerates devices.
  systemd.user.services.realtek-audio-profile = {
    description = "Force Realtek ALC897 to analog stereo profile";
    after = [ "wireplumber.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "realtek-audio-profile" ''
        for i in $(seq 1 30); do
          if ${pkgs.pulseaudio}/bin/pactl list cards short 2>/dev/null | grep -q alsa_card.pci-0000_12_00.6; then
            ${pkgs.pulseaudio}/bin/pactl set-card-profile alsa_card.pci-0000_12_00.6 output:analog-stereo+input:analog-stereo
            exit 0
          fi
          sleep 1
        done
        exit 1
      '';
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
}
