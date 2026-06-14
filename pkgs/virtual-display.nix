{ pkgs, ... }:

let
  # Identify your free connector by running on nixstation:
  # for p in /sys/class/drm/*/status; do con=${p%/status}; echo -n "${con#*/card?-}: "; cat $p; done
  connector = "HDMI-A-3";

  edidName = "samsung-q800t-hdmi2.1";
  edidFile = pkgs.fetchurl {
    url = "https://git.linuxtv.org/v4l-utils.git/plain/utils/edid-decode/data/samsung-q800t-hdmi2.1";
    sha256 = "0r3v1mzpkalgdhnnjfq8vbg4ian3pwziv0klb80zw89w1msfm9nh";
  };
in
{
  hardware.firmware = [
    (pkgs.runCommand "virtual-display-edid" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${edidFile} $out/lib/firmware/edid/${edidName}
    '')
  ];

  boot.initrd.extraFiles."lib/firmware/edid/${edidName}".source = edidFile;

  boot.kernelParams = [
    "drm.edid_firmware=${connector}:edid/${edidName}"
    "video=${connector}:e"
  ];
}
