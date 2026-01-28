{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware/nixvm-hardware.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixvm";

  users.users.dan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "24.11";
}
