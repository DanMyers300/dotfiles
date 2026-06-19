{ ... }:
{

  imports = [
    ./hyprlock.nix
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.configType = "hyprlang";
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland.extraConfig = ''
    # https://wiki.hyprland.org/Configuring/Configuring-Hyprland/
    # source = ~/.config/hypr/myColors.conf

    ################
    ### MONITORS ###
    ################

    # https://wiki.hyprland.org/Configuring/Monitors/

    workspace = 1, monitor:DP-2, default:true
    workspace = 2, monitor:HDMI-A-1, default:true
    workspace = 3, monitor:HDMI-A-2, default:true

    ### - DP-2 Scale 1 Setup ###
    monitor = DP-2, 3840x2160@160, 0x0, 1
    monitor = HDMI-A-1, 1920x1080@60, 3840x0, 1
    monitor = HDMI-A-2, 1920x1080@60, 5760x0, 1
    monitor = HDMI-A-3, disable
    ### --- ###

    ### - Default Setup ###
    #monitor = DP-2, 3840x2160@160, 0x0, 2
    #monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
    #monitor = HDMI-A-2, 3840x2160@60, 3840x0, 1
    #monitor = HDMI-A-3, disable
    ### --- ###

    ### - HDMI Mirror Setup ###
    #monitor = DP-2, 3840x2160@160, 0x0, 1
    #monitor = HDMI-A-1, 1920x1080@60, 3840x0, 1
    #monitor = HDMI-A-2, 3840x2160@60, auto, 1, mirror, HDMI-A-1
    #monitor = HDMI-A-3, disable
    ### --- ###

    ###################
    ### MY PROGRAMS ###
    ###################

    # https://wiki.hyprland.org/Configuring/Keywords/
    $terminal = ghostty
    $browser = zen
    $fileManager = thunar
    $menu = exec noctalia msg panel-toggle launcher

    #################
    ### AUTOSTART ###
    #################
    exec-once = blueman-applet
    exec-once = steam
    #exec-once = "hyprctl setcursor rose-pine-hyprcursor 18"
    exec-once = systemctl --user start sunshine

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # See https://wiki.hyprland.org/Configuring/Environment-variables/

    #env = XCURSOR_SIZE,8
    #env = XCURSOR_THEME,Bibata-Modern-Classic
    #env = HYPRCURSOR_SIZE,24
    #env = HYPRCURSOR_THEME,Bibata-Modern-Classic

    #####################
    ###   SSH  KEYS   ###
    #####################

    exec-once = ssh-add ~/.ssh/github

    #####################
    ### LOOK AND FEEL ###
    #####################

    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general { 
        gaps_in = 5
        gaps_out = 5

        border_size = 2

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false 

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false

        layout = dwindle
    }

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration {
        rounding = 10

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0
        inactive_opacity = 1.0

        #drop_shadow = true
        #shadow_range = 4
        #shadow_render_power = 3
        #col.shadow = rgba(1a1a1aee)

        shadow {
          enabled = true
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur {
            enabled = true
            size = 3
            passes = 1
            
            vibrancy = 0.1696
        }
    }

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations {
        enabled = true

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle {
        preserve_split = true
    }

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master {
        new_status = master
    }

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc {
        force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
    }


    #############
    ### INPUT ###
    #############

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

        touchpad {
            natural_scroll = false
        }
    }

    # https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs
    device {
        name = pixart-hp-320m-usb-optical-mouse
        sensitivity = -0.9
    }


    ####################
    ### KEYBINDINGS ###
    ####################

    # https://wiki.hyprland.org/Configuring/Keywords/
    $mainMod = SUPER

    # https://wiki.hyprland.org/Configuring/Binds/

    ### --- Applications --- ###
    bindl=,switch:Lid Switch, exec, hyprlock

    bind = $mainMod, T, exec, $terminal
    bind = $mainMod, B, exec, $browser
    bind = $mainMod, I, exec, pavucontrol
    bind = $mainMod, SPACE, exec, $menu
    bind = $mainMod, e, exec, $fileManager
    bind = , print, exec, grimshot copy area
    bind = $mainMod CTRL, S, exec, grimshot copy area

    ### --- System --- ###
    bind = $mainMod, Q, killactive,
    bind = $mainMod CTRL ALT, Q, exit,
    bind = $mainMod ALT, F, togglefloating
    bind = $mainMod, F, fullscreen, 1
    bind = $mainMod CTRL, F, fullscreen
    bind = $mainMod CTRL, H, movewindow, l
    bind = $mainMod CTRL, L, movewindow, r
    bind = $mainMod CTRL, K, movewindow, u
    bind = $mainMod CTRL, J, movewindow, d
    bind = CTRL ALT, Delete, exec, hyprlock
    bind = ,XF86AudioLowerVolume, exec, pactl -- set-sink-volume 0 -10%
    bind = ,XF86AudioRaiseVolume, exec, pactl -- set-sink-volume 0 +10%
    bind = ,XF86AudioMute, exec, pactl -- set-sink-mute 0 toggle
    bind = ,XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle
    bind = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
    bind = ,XF86MonBrightnessUp, exec, brightnessctl s +10%

    # Move focus with mainMod + vim binds
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Move workspace to another monitor with CTRL + ALT + SHIFT + MOD + h/l
    bind = CTRL ALT $mainMod SHIFT, h, movecurrentworkspacetomonitor, l
    bind = CTRL ALT $mainMod SHIFT, l, movecurrentworkspacetomonitor, r

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move to the left workspace
    bind = $mainMod ALT, h, workspace, -1

    # Move to the right workspace
    bind = $mainMod ALT, l, workspace, +1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Mute
    #bind = SUPER, M, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bind = SUPER, M, exec, noctalia msg mic-mute

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

  '';
}
