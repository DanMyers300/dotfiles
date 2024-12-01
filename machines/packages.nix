{
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
  qemu
  nvtopPackages.amd
  swtpm
  git
  p7zip
  gcc
  linuxKernel.packages.linux_zen.xpadneo
  #rust-bin.stable.latest.default     -- Enable if using flake overlay
  rustup
  ## Arduino
  avrdude
  pkgsCross.avr.buildPackages.gcc
  ollama
  nerdfonts
  sway-contrib.grimshot
  hyprlock
  wofi
  signal-desktop
  r2modman
];
}
