{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/nixbook-hardware.nix
      ../pkgs/packages.nix
      ../pkgs/stylix.nix
    ];

### --- Boot loader --- ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

### --- Wifi drivers --- ###
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.broadcom_sta
  ];

### --- Kernel --- ###
  boot.kernelPackages = pkgs.linuxPackages_latest;

### --- Bluetooth --- ###
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

### --- Networking --- ###
  networking.hostName = "nixbook";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    #allowedUDPPortRanges = [
      #{ from = 4000; to = 4007; }
      #{ from = 8000; to = 8010; }
    #];
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
  ]);

### --- Hyprland --- ###
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

### --- Crucial Programs --- ###
  environment.variables.EDITOR = "nvim";

### --- VPN --- ###
  services.mullvad-vpn.enable = true;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

### --- Audio --- ###
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

### --- Package settings --- ###
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "broadcom-sta-6.30.223.271-59-6.18.1"
    ];
  };

### --- User setup --- ###
  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    home = "/home/dan";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
