{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/nixbook-hardware.nix
      ../pkgs/packages.nix
      ../pkgs/steam.nix
      ../pkgs/stylix.nix
    ];

### --- Boot loader --- ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

### --- Wifi drivers --- ###
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "hid_apple" "kvm-intel" "wl" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.broadcom_sta
  ];
  boot.kernelParams = [ "hid_apple.fnmode=2" ];

### --- Kernel --- ###
  boot.kernelPackages = pkgs.linuxPackages_latest;

### --- Graphics --- ###
  hardware.opengl.enable = true;

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

  services.tailscale.enable = true;

  # Bypass Tailscale DERP servers from exit node routing
  # When using exit node, all traffic goes through Tailscale's routing table 52
  # We need to add specific routes for DERP servers to bypass the VPN tunnel
  services.tailscale.useRoutingFeatures = "both";

  systemd.services.tailscale-derp-bypass = {
    description = "Add routes to bypass Tailscale DERP servers from exit node";
    after = [ "network-online.target" "NetworkManager-wait-online.service" ];
    wants = [ "network-online.target" ];
    requires = [ "NetworkManager-wait-online.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = with pkgs; [ iproute2 gawk gnugrep coreutils ];

    script = ''
      set -e

      # Wait for NetworkManager to be fully up
      sleep 2

      # Get the main WiFi/Ethernet interface (not docker, not tailscale)
      MAIN_IF=$(ip route | grep "^default" | grep -v "tailscale" | awk '{print $5}' | head -1)

      if [ -z "$MAIN_IF" ]; then
        echo "ERROR: Could not find main network interface"
        exit 1
      fi

      # Get gateway for that interface
      DEFAULT_GW=$(ip route | grep "^default.*$MAIN_IF" | awk '{print $3}' | head -1)

      if [ -z "$DEFAULT_GW" ]; then
        echo "ERROR: Could not find default gateway for $MAIN_IF"
        exit 1
      fi

      echo "Using gateway $DEFAULT_GW on interface $MAIN_IF"

      # DERP server subnets
      DERP_SUBNETS=(
        "209.177.156.0/24" "192.73.248.0/24" "192.73.240.0/24"
        "192.73.242.0/24" "192.73.243.0/24" "192.73.244.0/24"
        "192.73.252.0/24" "199.38.181.0/24" "199.38.182.0/24"
        "209.177.145.0/24" "209.177.158.0/24" "208.111.34.0/24"
        "208.111.40.0/24" "208.72.155.0/24" "208.83.233.0/24"
        "208.83.234.0/24" "176.58.88.0/24" "176.58.90.0/24"
        "176.58.92.0/24" "176.58.93.0/24"
      )

      for subnet in "''${DERP_SUBNETS[@]}"; do
        echo "Adding route for $subnet"
        # Add to main table
        ip route add "$subnet" via "$DEFAULT_GW" dev "$MAIN_IF" 2>/dev/null || true
        # Add to Tailscale's routing table 52
        ip route add "$subnet" via "$DEFAULT_GW" dev "$MAIN_IF" table 52 2>/dev/null || true
      done

      echo "DERP bypass routes added successfully"
      ip route show table 52 | grep -E "209.177|192.73" | head -5
    '';
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

### --- Docker --- ###
  virtualisation.docker.enable = true;

### --- User setup --- ###
  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    home = "/home/dan";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
