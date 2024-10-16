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

# Programming Lang
  zig
  python3
  nodejs_22

# System Tools
  mullvad-vpn
  pavucontrol
  qemu
  gnome-extension-manager

];
}
