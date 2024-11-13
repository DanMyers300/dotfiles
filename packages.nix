{
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
# System Tools
  mullvad-vpn
  pavucontrol
  qemu
  gnome-extension-manager
  hyprlock
  bluez-tools
  nvtopPackages.amd
  swtpm
  git
  p7zip
  gcc
  btop
  baobab
  ripgrep

  # Arduino
  #avrlibc
  #pkgsCross.avr.buildPackages.gcc
  #pkg-config
  avrdude

  # for game controllers:
  linuxKernel.packages.linux_zen.xpadneo

# Programming Lang
  zig
  python3
  mullvad-vpn
  typescript
  nodejs_22
  jdk
  lua54Packages.lua
  lua54Packages.luacheck
  #rust-bin.stable.latest.default     -- Enable if using flake overlay
  rustup
  ## Arduino
  pkgsCross.avr.buildPackages.gcc
];
}
