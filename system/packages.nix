{
  config,
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [

# Necessary
  git
  p7zip
  gcc
  btop
  baobab
  ripgrep

# Programming Lang
  zig
  python3
  nodejs_22
  jdk

# System Tools
  mullvad-vpn
  pavucontrol
  qemu
  gnome-extension-manager
  hyprlock
  bluez-tools
  blueman
  nvtopPackages.amd
  swtpm

];
}
