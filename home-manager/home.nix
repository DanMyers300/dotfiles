{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  imports = [
    ./programs.nix
    ./config/nvim/nvimrc.nix
    ./config/nvim/nvimPlugins.nix
    ./config/stylix.nix
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
    stateVersion = "24.05";
    username = "dan";
    homeDirectory = "/home/dan";
  };

  systemd.user.startServices = "sd-switch";
}
