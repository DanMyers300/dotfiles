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
  mullvad-vpn
  typescript
  nodejs_22
  jdk
  lua54Packages.lua
  lua54Packages.luacheck

# System Tools
  mullvad-vpn
  pavucontrol
  qemu
  gnome-extension-manager
  hyprlock
  bluez-tools
  nvtopPackages.amd
  swtpm

];
}
