{ config, pkgs, unstable, ... } : {

  imports = [
    ../pkgs/nvim.nix
    ../pkgs/alacritty.nix
    ../pkgs/hypr.nix
    ../pkgs/bash.nix
    ../pkgs/tmux.nix
    ../pkgs/redshift.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "dan";
    homeDirectory = "/home/dan";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
