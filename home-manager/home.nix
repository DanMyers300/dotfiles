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

  disabledModules = [ "${inputs.stylix}/modules/kubecolor/hm.nix" ];
  stylix = {
    targets = {
      neovim = {
        enable = true;
        transparentBackground.main = true;
      };
    };
  };

  programs.home-manager.enable = true;
  wayland.windowManager.hyprland.systemd.variables = ["--all"];
  systemd.user.startServices = "sd-switch";
}
