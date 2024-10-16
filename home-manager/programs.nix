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
    waybar
  ];
}
