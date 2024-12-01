{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  imports = [
    ./programs.nix
    ../config/nvim/nvimrc.nix
    ../config/nvim/nvimPlugins.nix
    ../config/nvim/nvimSettings.nix
    ../config/stylix.nix
    ../config/alacritty.nix
    ../config/bash.nix
    ../config/tmux.nix
    ../config/hypr.nix
    ../config/redshift.nix
  ];

  nixpkgs = {
    overlays = [
      # neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    stateVersion = "24.11";
    username = "dan";
    homeDirectory = "/home/dan";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
