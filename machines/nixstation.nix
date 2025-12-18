{
  inputs,
  lib,
  config,
  pkgs,
  unstable,
  ...
}:{

  imports =
    [
      ./hardware/nixstation-hardware.nix
      ../pkgs/packages.nix
      ../pkgs/steam.nix
      ../pkgs/stylix.nix
      ../pkgs/ollama.nix
    ];

### --- Boot loader --- ###
  boot.loader.grub = {
    enable = true;
    devices = ["nodev"];
    efiSupport = true;
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

### --- Kernel --- ###
  boot.kernelPackages = pkgs.linuxPackages_latest;

### --- Bluetooth --- ###
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

### --- Localization --- ###
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
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
  environment.gnome.excludePackages = (with pkgs; [
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
  ]);

### --- Hyprland --- ###
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

### --- Virtualisation --- ###
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  #virtualisation.spiceUSBRedirection.enable = true;

### --- Networking --- ###
  networking = {
    hostName = "nixstation";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 25565 ];
      allowedUDPPorts = [];
    };
    extraHosts =
      ''
        192.168.1.15 nixserver
        192.168.1.11 mac
        192.168.1.9 nixtop
        192.168.1.3 raspberrypi
      '';
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

### --- VPN --- ###
  services.mullvad-vpn.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

### --- Audio --- ###
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
   enable = true;
   alsa.enable = true;
   alsa.support32Bit = true;
   pulse.enable = true;
  };

### --- Package settings --- ###
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

### --- User setup --- ###
  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEVdbTZeHyd3Hy5Yz1eQWKg+4xhKt3blqFLjjrgtnsH dan@nixtop"
    ];
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "input" ];
  };

### --- Config for game controller --- ###
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  services.joycond.enable = true;

### --- ENV VARs --- ###
  environment.variables = {
    EDITOR = "nvim";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

### --- Version --- ###
  system.stateVersion = "25.11";
}
