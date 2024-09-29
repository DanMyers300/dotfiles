{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";
    image = pkgs.fetchurl {
      url = "https://images.pexels.com/photos/956981/milky-way-starry-sky-night-sky-star-956981.jpeg";
      sha256 = "";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    fonts = {
      sizes = {
        applications = 9;
        desktop = 9;
        popups = 9;
      };
    };
    targets = {
      neovim = {
        enable = true;
        #transparentBackground.main = true;
        #transparentBackground.signColumn = true;
      };
    };
  };

}
