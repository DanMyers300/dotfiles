{ pkgs, ... }:
{

  ### --- Kernel --- ###
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;

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

  ### --- Networking --- ###
  networking.networkmanager.enable = true;

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
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  ### --- ENV VARs --- ###
  environment.variables.EDITOR = "nvim";

  ### --- User setup --- ###
  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
