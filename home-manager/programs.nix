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
    kitty
    tmux
    qbittorrent
    vlc
    steam
    ollama
    signal-desktop
  ];

  programs = {
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
    };

    alacritty = {
      enable = true;
      settings = {
        window = {
          title="Nixstation";
          dynamic_title=false;
          opacity= lib.mkForce 0.8;
        };
      };
    };

    home-manager.enable = true;
  };
}
