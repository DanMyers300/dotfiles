{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  services = {
    gammastep = {
      enable = true;
      latitude = "32.973531938214734";
      longitude = "-96.71429473056209";
    };
  };
}
