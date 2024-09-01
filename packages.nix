{ config, pkgs, ... } :

{
environment.systemPackages = with pkgs; [
  git
  neovim
  alacritty
  parsec-bin
  tmux
  python3
];
}
