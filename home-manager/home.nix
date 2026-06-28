{ ... }:
{

  imports = [
    ./configs/nvim.nix
    ./configs/ghostty.nix
    ./configs/bash.nix
    ./configs/tmux.nix
    ./configs/redshift.nix
    ./configs/hyprland.nix
    ./configs/noctalia.nix
  ];

  home = {
    stateVersion = "26.05";
    username = "dan";
    homeDirectory = "/home/dan";
  };

  stylix.targets.qt.enable = false;

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;
}
