{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  disabledModules = [ "${inputs.stylix}/modules/kubecolor/hm.nix" ];
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = builtins.toPath ../home-manager/themes/tokyo-night.yaml;
    image = ../background.jpeg;
    polarity = "dark";
    targets.gnome.enable = false;
    targets.grub.enable = false;
    targets.qt.enable = false;
    cursor = {
      package = pkgs.bibata-cursors;
      size = 12;
      name = "Bibata-Modern-Classic";
    };
    fonts = {
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };
  };
}
