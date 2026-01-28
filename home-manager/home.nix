{
  config,
  pkgs,
  unstable,
  ...
}:
{

  imports = [
    ./configs/nvim.nix
    ./configs/ghostty.nix
    ./configs/hypr.nix
    ./configs/bash.nix
    ./configs/tmux.nix
    ./configs/redshift.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "dan";
    homeDirectory = "/home/dan";
  };

  stylix.targets.hyprlock.enable = false;
  stylix.targets.waybar.enable = false;
  stylix.targets.gnome.enable = false;

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
