{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  home.packages = with pkgs; [
    prismlauncher
    qbittorrent
    vlc
    ollama
    nerdfonts
    sway-contrib.grimshot
    blueman
  ];
}
