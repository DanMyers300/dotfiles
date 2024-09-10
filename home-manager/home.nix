{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  imports = [
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
    packages = with pkgs; [ 
    # steam
      prismlauncher
      nodejs_22
      baobab
      alacritty
      tmux
    ];
  };
  
  programs = {
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
    };

    home-manager.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
