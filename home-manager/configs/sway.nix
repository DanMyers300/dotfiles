{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    swaylock
    swayidle
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
  };

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
          "${mod}+t" = "exec ghostty";
          "${mod}+i" = "exec pavucontrol";
          "${mod}+b" = "exec zen";
          "${mod}+e" = "exec nautilus";
          "Print" = "exec bash -c 'grim -g \"$(slurp)\" - | wl-copy'";
          "${mod}+Space" = "exec wofi --show run";
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+l" = "exec swaylock -f";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Ctrl+h" = "move left";
          "${mod}+Ctrl+j" = "move down";
          "${mod}+Ctrl+k" = "move up";
          "${mod}+Ctrl+l" = "move right";

          "${mod}+m" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "${mod}+period" = "splith";
          "${mod}+comma" = "splitv";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+p" = "layout toggle split";

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
