{
  config,
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
    git
    btop
    zig
    gcc
    python3
    steam
  ];
}
