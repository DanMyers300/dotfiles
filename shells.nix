{ pkgs ? import <nixpkgs> {} }:

{
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
