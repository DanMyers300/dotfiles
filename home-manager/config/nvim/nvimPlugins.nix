{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  programs.neovim.plugins = [
    pkgs.vimPlugins.catppuccin-nvim
  ];
}
