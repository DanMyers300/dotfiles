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
  mullvad-vpn
  pavucontrol

  # Hyprland
  wl-clipboard
  nerdfonts
  sway-contrib.grimshot
  wofi

  ] ++ (if config.networking.hostName == "nixstation" then [

  libreoffice
  ungoogled-chromium
  nvtopPackages.amd
  nvtopPackages.full

  # Virtualization
  qemu
  swtpm

  # Games
  r2modman
  prismlauncher
  # Game pads
  linuxKernel.packages.linux_zen.xpadneo

  ] else []);
}
