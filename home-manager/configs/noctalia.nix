{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

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
