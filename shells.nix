{ pkgs ? import <nixpkgs> {} }:

{

  node = pkgs.mkShell {
    name = "node-env";
    buildInputs = with pkgs; [
      nodejs
      nodePackages.typescript-language-server
    ];

    shellHook = ''
      export NODE_VERSION=$(node --version)
      echo "Welcome to the Node development environment! Node version: $NODE_VERSION"
    '';
  };

  zig = pkgs.mkShell {
    name = "zig-env";
    buildInputs = [
      pkgs.zig
    ];

    shellHook = ''
      export ZIG_VERSION=$(zig version)
      echo "Welcome to the Zig development environment! Zig version: $ZIG_VERSION"
    '';
  };

  rust = pkgs.mkShell {
    name = "rust-env";
    buildInputs = [
      pkgs.rustc
      pkgs.cargo
    ];

    shellHook = ''
      echo "Welcome to the Rust development environment!"
    '';
  };

  python = pkgs.mkShell {
    name = "python-env";
    buildInputs = [
      pkgs.python3
      pkgs.python3Packages.pip
    ];

    shellHook = ''
      echo "Welcome to the Python development environment!"
    '';
  };
}
