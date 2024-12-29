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
      url = "https://images.unsplash.com/photo-1511800453077-8c0afa94175f";
      sha256 = "sha256-jGi50sy6Zjc1xuop670lFBA2UX3mvekB+EA4Fenjeek";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.adwaita-icon-theme;
      size = 1;
      name = "Adwaita";
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
      neovim.enable = false;
    };
  };
}
