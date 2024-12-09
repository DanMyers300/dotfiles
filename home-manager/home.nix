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
    ../pkgs/redshift.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "dan";
    homeDirectory = "/home/dan";
    packages = with pkgs; [
      gnomeExtensions.paperwm
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
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        paperwm.extensionUuid
      ];
    };
  };


  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
