{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  home-manager.users.myuser = {
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          clipboard-history.extensionUuid
        ];
      };
    };
  };
}
