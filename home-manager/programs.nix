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

  programs = {

    alacritty = {
      enable = true;
      settings = {
        window = {
          title = "Nixstation";
          dynamic_title = false;
          opacity = lib.mkForce 0.8;
        };
      };
    };

    home-manager.enable = true;
  };
}
