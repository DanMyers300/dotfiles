{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  imports = [
    ../pkgs/nvim.nix
    ../pkgs/hypr.nix
    ../pkgs/bash.nix
    ../pkgs/tmux.nix
    ../pkgs/redshift.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "dan";
    homeDirectory = "/home/dan";
    packages = with pkgs; [
      gnomeExtensions.transparent-top-bar
      vesktop
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          transparent-top-bar.extensionUuid
        ];
      };
    };
  };

  home.file = {
    ".config/ghostty" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/dan/dotfiles/.config/ghostty";
    };
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/dan/dotfiles/.config/nvim";
    };
  };

  stylix.targets.neovim.enable = false;

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
