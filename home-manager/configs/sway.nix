{ config, pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "wofi --show run";

      output = {
        "DP-2"     = { mode = "1920x1080@60Hz"; position = "0,0"; };
        "HDMI-A-1" = { mode = "1920x1080@60Hz"; position = "1920,0"; };
        "HDMI-A-2" = { mode = "3840x2160@60Hz"; position = "3840,0"; };
      };

      input = {
        "*" = {
          xkb_layout = "us";
        };
      };

      keybindings =
        let mod = config.wayland.windowManager.sway.config.modifier;
        in {
          "${mod}+Return" = "exec ghostty";
          "${mod}+d" = "exec wofi --show run";
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+r" = "reload";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Ctrl+h" = "move left";
          "${mod}+Ctrl+j" = "move down";
          "${mod}+Ctrl+k" = "move up";
          "${mod}+Ctrl+l" = "move right";

          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";

          "${mod}+Ctrl+1" = "move container to workspace number 1";
          "${mod}+Ctrl+2" = "move container to workspace number 2";
          "${mod}+Ctrl+3" = "move container to workspace number 3";
          "${mod}+Ctrl+4" = "move container to workspace number 4";
          "${mod}+Ctrl+5" = "move container to workspace number 5";
        };

      bars = [];
    };
  };
}
