{
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
  # System
  nvtopPackages.amd
  bluez-tools
  mullvad-vpn
  pavucontrol
  wl-clipboard
  nerdfonts
  sway-contrib.grimshot
  gnome-extension-manager
  hyprlock
  wofi

  # Game pads
  linuxKernel.packages.linux_zen.xpadneo

  # Programming lang
  gcc
    # Rust
  rustup
  lua54Packages.lua
  libarchive
    # --

  ## Arduino
  avrdude
  pkgsCross.avr.buildPackages.gcc

  # Virtualization
  qemu
  swtpm

  # Utils
  libreoffice
  btop
  baobab
  ripgrep
  git
  p7zip

  # Games
  r2modman
  prismlauncher
];
}
