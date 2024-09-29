{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  home.packages = with pkgs; [
    prismlauncher
    baobab
    alacritty
    kitty
    tmux
    qbittorrent
    vlc
    steam
  ];

  programs = {
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
    };

    home-manager.enable = true;
  };
}
