{
  inputs,
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [

  git
  btop
  inputs.ghostty.packages.x86_64-linux.default
  p7zip
  ripgrep
  bluez-tools
  baobab
  nvtopPackages.amd
  nvtopPackages.full
  mullvad-vpn
  pavucontrol
  libreoffice
  ungoogled-chromium

  # Hyprland
  wl-clipboard
  nerdfonts
  sway-contrib.grimshot
  wofi

  # Virtualization
  qemu
  swtpm

  # Games
  r2modman
  prismlauncher
  # Game pads
  linuxKernel.packages.linux_zen.xpadneo

];
}
