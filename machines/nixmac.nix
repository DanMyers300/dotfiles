{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    ./common.nix
    ./hardware/nixmac-hardware.nix
    ../pkgs/packages.nix
    ../pkgs/stylix.nix
  ];

  ### --- Boot loader --- ###
  boot.loader.systemd-boot.enable = true;

  ### --- Intel Graphics (fixes idle display crashes) --- ###
  hardware.graphics.enable = true;
  boot.kernelParams = [
    "i915.enable_psr=0"    # disable panel self-refresh
    "i915.enable_fbc=0"    # disable framebuffer compression
    "i915.enable_rc6=0"    # disable render standby (main idle crash culprit)
  ];

  ### --- Bluetooth --- ###
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  systemd.sleep.extraConfig = ''
  AllowSuspend=no
  AllowHibernation=no
  AllowHybirdSleep=no
  AllowSuspendThenHibernate=no
  '';

  ### --- Networking --- ###
  networking.hostName = "nixmac";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
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

  ### --- Hyprland --- ###
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ### --- User setup --- ###
  users.users.dan.extraGroups = [ "libvirtd" ];

  ### --- Version --- ###
  system.stateVersion = "24.11";
}
