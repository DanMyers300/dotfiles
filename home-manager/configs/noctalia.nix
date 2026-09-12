{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia shell bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      X-Restart-Triggers = [ "${config.xdg.configFile."noctalia/config.toml".source}" ];
    };
    Service = {
      ExecStartPre = "-${pkgs.procps}/bin/pkill quickshell";
      ExecStart = "${config.programs.noctalia.package}/bin/noctalia";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.noctalia = {
      enable = true;
      settings = {
        widget.input-volume = {
          type = "volume";
          device = "input";
        };
        bar = {
          main = {
            position = "top";
            margin_ends = 10;
            margin_edge = 5;
            start = ["launcher" "workspaces"];
            center = ["clock"];
            end = ["tray" "clipboard" "network" "bluetooth" "volume" "input-volume" "brightness" "battery" "session"];
          };
        };
        widget.clock = {
          format = "{:%H:%M:%S}";
        };
        theme = {
          mode = "dark";
          source = "community";
          community = "Oxocarbon";
        };
        wallpaper = {
          enabled = false;
        };
        location = {
          monthBeforeDay = true;
          name = "Austin, Texas";
        };
        notifications = {
          density = "compact";
        };
        general = {
          enableShadows = false;
        };
      };
    };
}
