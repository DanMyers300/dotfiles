{ pkgs, ... }:

let
  connector = "HDMI-A-3";

  edidName = "samsung-q800t-hdmi2.1";
  edidFile = pkgs.fetchurl {
    url = "https://git.linuxtv.org/v4l-utils.git/plain/utils/edid-decode/data/samsung-q800t-hdmi2.1";
    sha256 = "0r3v1mzpkalgdhnnjfq8vbg4ian3pwziv0klb80zw89w1msfm9nh";
  };

  hyprctl = "${pkgs.hyprland}/bin/hyprctl";

  prepScript = pkgs.writeShellScript "sunshine-prep" ''
    # Save current cursor position
    IFS=', ' read -r X Y <<< "$(${hyprctl} cursorpos)"
    echo "$X $Y" > /tmp/sunshine-cursor-pos

    ${hyprctl} --instance 0 keyword monitor "HDMI-A-3,1920x1080@60,7680x0"
    sleep 2
    ${hyprctl} --instance 0 keyword monitor "DP-2,disable"
    ${hyprctl} --instance 0 keyword monitor "HDMI-A-1,disable"
    ${hyprctl} --instance 0 keyword monitor "HDMI-A-2,disable"

    # Snap cursor to center of virtual display (7680 + 1920/2, 1080/2)
    ${hyprctl} dispatch movecursor 8640 540
  '';

  exitScript = pkgs.writeShellScript "sunshine-exit" ''
    ${hyprctl} --instance 0 keyword monitor "DP-2,3840x2160@160,0x0,1"
    ${hyprctl} --instance 0 keyword monitor "HDMI-A-1,1920x1080@60,3840x0,1"
    ${hyprctl} --instance 0 keyword monitor "HDMI-A-2,1920x1080@60,5760x0,1"
    ${hyprctl} --instance 0 keyword monitor "HDMI-A-3,disable"

    # Restore cursor to saved position
    if [ -f /tmp/sunshine-cursor-pos ]; then
      read -r X Y < /tmp/sunshine-cursor-pos
      ${hyprctl} dispatch movecursor "$X" "$Y"
      rm /tmp/sunshine-cursor-pos
    fi
  '';
in
{
  hardware.firmware = [
    (pkgs.runCommand "virtual-display-edid" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${edidFile} $out/lib/firmware/edid/${edidName}
    '')
  ];

  boot.kernelParams = [
    "drm.edid_firmware=${connector}:edid/${edidName}"
    "video=${connector}:e"
  ];

  services.sunshine.settings = {
    global_prep_cmd = builtins.toJSON [
      {
        do = "${prepScript}";
        undo = "${exitScript}";
        elevated = false;
      }
    ];
  };
}
