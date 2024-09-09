{
  config,
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
    git
    zig
    gcc
    python3
    steam
  ];
}
