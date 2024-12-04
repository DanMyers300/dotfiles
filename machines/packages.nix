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
  rustup
  lua54Packages.lua
  gcc

  ## Arduino
  avrdude
  pkgsCross.avr.buildPackages.gcc

  # Virtualization
  qemu
  swtpm

  # Utils
  signal-desktop
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
