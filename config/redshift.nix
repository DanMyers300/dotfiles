{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  services.redshift = {
    enable = true;
  };
}
