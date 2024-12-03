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
  signal-desktop
  r2modman
  gnome-extension-manager
  prismlauncher
  wl-clipboard
  nerdfonts
  sway-contrib.grimshot
  hyprlock
  wofi
  luaformatter
  webcord-vencord
  ungoogled-chromium
  libreoffice
  btop
  baobab
  ripgrep
  bluez-tools
  mullvad-vpn
  pavucontrol
  python3
  typescript
  unstable.deno
  jdk
  lua54Packages.lua
  lua54Packages.luacheck
  git
  p7zip
  gcc
];
}
