{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  imports = [
    ../pkgs/nvim/nvimrc.nix
    ../pkgs/nvim/nvimPlugins.nix
    ../pkgs/nvim/nvimSettings.nix
    ../pkgs/alacritty.nix
    ../pkgs/bash.nix
    ../pkgs/tmux.nix
    ../pkgs/hypr.nix
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
