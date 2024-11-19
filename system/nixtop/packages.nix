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
  swtpm
  git
  p7zip
  gcc
  btop
  baobab
  ripgrep
];
}
