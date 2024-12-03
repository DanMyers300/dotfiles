{
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
  # System
  nvtopPackages.amd
  btop
  baobab
  ripgrep
  bluez-tools
  mullvad-vpn
  pavucontrol
  wl-clipboard
  nerdfonts
  sway-contrib.grimshot
  gnome-extension-manager
  hyprlock
  wofi
  git
  p7zip
  gcc

  # Game pads
  linuxKernel.packages.linux_zen.xpadneo

  # Programming lang
  rustup
  lua54Packages.lua

  ## Arduino
  avrdude
  pkgsCross.avr.buildPackages.gcc

  # Virtualization
  qemu
  swtpm

  # MISC
  signal-desktop
  r2modman
  prismlauncher
  libreoffice
];
}
