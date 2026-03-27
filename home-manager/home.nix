{
  config,
  lib,
  pkgs,
  osConfig,
  unstable,
  ...
}:
{

  imports = [
    ./configs/nvim.nix
    ./configs/ghostty.nix
    ./configs/bash.nix
    ./configs/tmux.nix
    ./configs/redshift.nix
    ./configs/sway.nix
    ./configs/waybar.nix
    ./configs/noctalia.nix
  ];

  home = {
    stateVersion = "25.11";
    username = "dan";
    homeDirectory = "/home/dan";
  };

  stylix.targets.waybar.enable = false;

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
