{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  imports = [
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
    packages = with pkgs; [
      gnomeExtensions.transparent-top-bar
      vesktop
    ];
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

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
