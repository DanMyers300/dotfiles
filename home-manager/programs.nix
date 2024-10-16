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
    qbittorrent
    vlc
    steam
    ollama
    signal-desktop
  ];
}
