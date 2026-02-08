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
    ../pkgs/ollama.nix
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
  services.blueman.enable = true;

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
    enable = true;
    xwayland.enable = true;
  };

  ### --- Virtualisation --- ###
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  ### --- Networking --- ###
  networking = {
    hostName = "nixstation";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 47990 5984 ];
      allowedUDPPorts = [ ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall.checkReversePath = "loose";

  # Bypass Tailscale DERP servers from exit node routing
  # When using exit node, all traffic goes through Tailscale's routing table 52
  # We need to add specific routes for DERP servers to bypass the VPN tunnel
  #services.tailscale.useRoutingFeatures = "both";

  #systemd.services.tailscale-derp-bypass = {
  #  description = "Add routes to bypass Tailscale DERP servers from exit node";
  #  after = [ "network-online.target" "NetworkManager-wait-online.service" ];
  #  wants = [ "network-online.target" ];
  #  requires = [ "NetworkManager-wait-online.service" ];
  #  wantedBy = [ "multi-user.target" ];

  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #  };

  #  path = with pkgs; [ iproute2 gawk gnugrep coreutils ];

  #  script = ''
  #    set -e

  #    # Wait for NetworkManager to be fully up
  #    sleep 2

  #    # Get the main WiFi/Ethernet interface (not docker, not tailscale)
  #    MAIN_IF=$(ip route | grep "^default" | grep -v "tailscale" | awk '{print $5}' | head -1)

  #    if [ -z "$MAIN_IF" ]; then
  #      echo "ERROR: Could not find main network interface"
  #      exit 1
  #    fi

  #    # Get gateway for that interface
  #    DEFAULT_GW=$(ip route | grep "^default.*$MAIN_IF" | awk '{print $3}' | head -1)

  #    if [ -z "$DEFAULT_GW" ]; then
  #      echo "ERROR: Could not find default gateway for $MAIN_IF"
  #      exit 1
  #    fi

  #    echo "Using gateway $DEFAULT_GW on interface $MAIN_IF"

  #    # DERP server subnets
  #    DERP_SUBNETS=(
  #      "209.177.156.0/24" "192.73.248.0/24" "192.73.240.0/24"
  #      "192.73.242.0/24" "192.73.243.0/24" "192.73.244.0/24"
  #      "192.73.252.0/24" "199.38.181.0/24" "199.38.182.0/24"
  #      "209.177.145.0/24" "209.177.158.0/24" "208.111.34.0/24"
  #      "208.111.40.0/24" "208.72.155.0/24" "208.83.233.0/24"
  #      "208.83.234.0/24" "176.58.88.0/24" "176.58.90.0/24"
  #      "176.58.92.0/24" "176.58.93.0/24"
  #    )

  #    for subnet in "''${DERP_SUBNETS[@]}"; do
  #      echo "Adding route for $subnet"
  #      # Add to main table
  #      ip route add "$subnet" via "$DEFAULT_GW" dev "$MAIN_IF" 2>/dev/null || true
  #      # Add to Tailscale's routing table 52
  #      ip route add "$subnet" via "$DEFAULT_GW" dev "$MAIN_IF" table 52 2>/dev/null || true
  #    done

  #    echo "DERP bypass routes added successfully"
  #    ip route show table 52 | grep -E "209.177|192.73" | head -5
  #  '';
  #};

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
      "docker"
      "input"
    ];
  };

  ### --- Config for game controller --- ###
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  services.joycond.enable = true;

  ### --- OpenGL --- ###
  hardware.opengl.enable = true;

  ### --- Flatpak --- ###
  services.flatpak.enable = true;

  ### --- Sunshine --- ###
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  ### --- Version --- ###
  system.stateVersion = "25.11";
}
