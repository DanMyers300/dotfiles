{ lib, ... }:{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        title = "Nixstation";
        dynamic_title = false;
        opacity = lib.mkForce 0.8;
      };
    };
  };
}
