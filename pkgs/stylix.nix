{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  disabledModules = [ "${inputs.stylix}/modules/kubecolor/hm.nix" ];
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";
    image = pkgs.fetchurl {
      url = "https://images.pexels.com/photos/1428277/pexels-photo-1428277.jpeg";
      sha256 = "sha256-oFQRvK/AVTCcOMrNboWSTBB5FQNz7AffDKObKqH8Usk=";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      size = 8;
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
    targets = {
      chromium.enable = false;
    };
  };
}
