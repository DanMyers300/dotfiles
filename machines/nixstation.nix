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

  ### --- Bluetooth --- ###
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = false;

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

  ### --- Cosmic --- ###
  services.desktopManager.cosmic.enable = true;
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
    cosmic-player
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  ### --- Gnome --- ###
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = false;
  services.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "dan";
  };
  programs.dconf.enable = true;
  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-connections
      gnome-photos
      gnome-tour
      gnome-music
      gnome-contacts
      gnome-initial-setup
      gedit # text editor
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
    ]
  );

  ### --- Hyprland --- ###
  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };


  ### --- Virtualisation --- ###
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  ### --- Networking --- ###
  networking = {
    hostName = "nixstation";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3000 47990 5984 ];
      allowedUDPPorts = [ ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall.checkReversePath = "loose";

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

  ### --- VPN --- ###
  services.mullvad-vpn.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  ### --- User setup --- ###
  users.users.dan = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEVdbTZeHyd3Hy5Yz1eQWKg+4xhKt3blqFLjjrgtnsH dan@nixtop"
    ];
    extraGroups = [
      "libvirtd"
      "kvm"
      "docker"
      "input"
      "dialout"
    ];
  };

  ### --- Config for game controller --- ###
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  services.joycond.enable = true;

  ### --- OpenGL --- ###
  hardware.graphics.enable = true;

  ### --- Flatpak --- ###
  services.flatpak.enable = true;

  ### --- Sunshine --- ###
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.nix-ld.enable = true;

  ### --- Version --- ###
  system.stateVersion = "25.11";
}
