{ pkgs ? import <nixpkgs> {} }:

{

  node = pkgs.mkShell {
    name = "node-env";
    buildInputs = with pkgs; [
      nodejs
      typescript
      nodePackages.typescript-language-server
    ];

    shellHook = ''
      export NODE_VERSION=$(node --version)
      export PS1="(node $NODE_VERSION) \[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    '';
  };

  zig = pkgs.mkShell {
    name = "zig-env";
    buildInputs = [
      pkgs.zig
    ];

    shellHook = ''
      export ZIG_VERSION=$(zig version)
      export PS1="(zig v$ZIG_VERSION) \[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    '';
  };

  rust = pkgs.mkShell {
    name = "rust-env";
    buildInputs = [
      pkgs.rustc
      pkgs.cargo
    ];

    shellHook = ''
      export RUST_VERSION=$(rustc --version | awk '{print $2}')
      export PS1="(rust v$RUST_VERSION) \[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    '';
  };

  python = pkgs.mkShell {
    name = "python-env";
    buildInputs = [
      pkgs.python3
      pkgs.python3Packages.pip
    ];

    shellHook = ''
      export PYTHON_VERSION=$(python3 --version | awk '{print $2}')
      export PS1="(python v$PYTHON_VERSION) \[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    '';
  };
}
