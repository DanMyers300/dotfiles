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
    ollama
    nerdfonts
    sway-contrib.grimshot
    wofi
    signal-desktop
    wl-clipboard
    luaformatter
    webcord-vencord
    unstable.deno
  ];
}
