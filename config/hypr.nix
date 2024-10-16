{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  wayland.windowManager.hyprland.enable = true;
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
