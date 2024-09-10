{
  config,
  pkgs,
  ...
} : {

environment.systemPackages = with pkgs; [
    git
    p7zip
    btop
    zig
    gcc
    python3
    steam
    openvpn
  ];
}
