{ lib, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
      keybind = [
        "alt+h=goto_split:left"
        "alt+j=goto_split:down"
        "alt+k=goto_split:up"
        "alt+l=goto_split:right"
      ];
    };
  };
}
