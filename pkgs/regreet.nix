{ pkgs, lib, ... }:
let
  greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
    output HDMI-A-2 disable
    output DP-2 disable
    exec "${pkgs.regreet}/bin/regreet; swaymsg exit"
  '';
in
{
  programs.regreet.enable = true;

  services.greetd.settings.default_session.command = lib.mkForce
    "${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --config ${greetdSwayConfig}";
}
