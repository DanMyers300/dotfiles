{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        border-radius: 6px;
        font-family: "JetBrains Mono";
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.4);
        color: #cdd6f4;
        border-radius: 6px;
        padding: 5px;
      }

      #window,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #workspaces,
      #cpu,
      #gpu-usage,
      #memory,
      #tray {
        background: rgba(30, 30, 46, 0.8);
        padding: 5px 10px;
        margin: 0px 5px;
        border: 1px solid rgba(24, 24, 37, 0.8);
        border-radius: 6px;
      }

      #custom-gpu-usage {
        background: rgba(30, 30, 46, 0.8);
        padding: 5px 10px;
        margin: 0px 5px;
        border: 1px solid rgba(24, 24, 37, 0.8);
        border-radius: 6px;
        color: #f5a97f; /* Choose a color for the GPU usage module */
      }

      #memory {
        color: #89dceb;
      }

      #cpu {
        color: #74c7ec;
      }

      #pulseaudio {
        color: #f38ba8;
      }

      #network {
        color: #cba6f7;
      }

      #clock {
        color: #a6e3a1;
        border-radius: 6px;
        margin-right: 5px;
      }

      #workspaces {
        background: rgba(30, 30, 46, 0.8);
        border-radius: 6px;
        margin-left: 5px;
        padding-right: 5px;
        padding-left: 5px;
      }
    '';
    settings = [
      {
        height = 30;
        layer = "top";
        tray = { spacing = 10; };
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "custom/gpu-usage"
          "temperature"
          "battery"
        ];
        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
        };
        cpu = {
          format = "{usage}%  ";
          tooltip = false;
        };
        memory = { format = "{}%  "; };
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}  up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%)  ";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} | {format_source}";
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
          format-muted = "No  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = " ";
          on-click = "pavucontrol";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        "custom/gpu-usage" = {
          format = "{} {icon}";
          exec = "/home/dan/.cargo/bin/gpu-usage-waybar";
          return-type = "json";
          format-icons = "󰾲";
          on-click = "alacritty -e nvtop";
        };
        battery = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "⚡{capacity}%";
          format-plugged = "{capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ " " " " " " " " " " ];
        };
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };
      }
    ];
  };
}

