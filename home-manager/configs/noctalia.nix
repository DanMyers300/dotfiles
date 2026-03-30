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
      X-Restart-Triggers = [ "${config.xdg.configFile."noctalia/settings.json".source}" ];
    };
    Service = {
      ExecStartPre = "-${pkgs.procps}/bin/pkill quickshell";
      ExecStart = "${pkgs.bash}/bin/bash -lc noctalia-shell";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
            center = [
              {
                formatHorizontal = "HH:mm:ss";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
            right = [
              {
                id = "Bluetooth";
              }
              {
                id = "Network";
              }
              {
                id = "Battery";
                warningThreshold = 30;
              }
              {
                id = "Workspace";
              }
            ];
          };
        };
        location = {
          monthBeforeDay = true;
          name = "Austin, Texas";
        };
        notifications = {
          density = "compact";
        };
      };
    };
}
