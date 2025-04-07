{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''

      window#waybar {
        background: transparent;
        background-color: rgba(0, 0, 0, 0.5); /* Black with 50% transparency */
        border-bottom: none;
      }
    '';
    # Add this to above style to use your own css
    #${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

    settings = [{
      height = 30;
      layer = "top";
      tray = { spacing = 10; };
      modules-left = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "clock"
      ];
      clock = {
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      cpu = {
        format = "{usage}%    |";
        tooltip = false;
      };
      memory = { format = "{}%    |"; };
      network = {
        interval = 1;
        format-alt = "{ifname}: {ipaddr}/{cidr}  |";
        format-disconnected = "Disconnected ⚠  |";
        format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        format-linked = "{ifname} (No IP) ";
        format-wifi = "{essid} ({signalStrength}%)     |";
      };
      pulseaudio = {
        format = " |  {volume}% {icon}   |  {format_source}   |";
        format-bluetooth = " |  {volume}% {icon}  | {format_source}  |";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = "";
          default = [ "" "" "" ];
          handsfree = "";
          headphones = "";
          headset = "";
          phone = "";
          portable = "";
        };
        format-muted = " |  No   |  {format_source}  |";
        format-source = "{volume}% ";
        format-source-muted = " ";
        on-click = "pavucontrol";
      };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
      };
      battery = {
        states = {
          good = 90;
          warning = 30;
          critical = 15;
        };
        format = "{icon}   {capacity}% |";
        format-charging = "⚡  {capacity}% |";
        format-plugged = "{capacity}%";
        format-alt = "{time} {icon}";
        format-icons = [ " " " " " " " " " " ];
      };
      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
      };
    }];
  };
}
