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

  # Hyprland
  wl-clipboard
  nerdfonts
  sway-contrib.grimshot
  wofi

  # Game pads
  linuxKernel.packages.linux_zen.xpadneo

  # Programming lang
  gcc
    # Rust
  rustup
  lua54Packages.lua
    # --
  deno
  python311
  python311Packages.pip

  ## Arduino
  avrdude
  pkgsCross.avr.buildPackages.gcc

  # Virtualization
  qemu
  swtpm

  # Utils
  libreoffice
  htop
  btop
  nvtopPackages.full
  baobab
  ripgrep
  git
  p7zip
  ungoogled-chromium

  # Games
  r2modman
  prismlauncher
];
}
