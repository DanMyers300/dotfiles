{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    zen-browser.url = "github:DanMyers300/zen-browser-flake";
    stylix.url = "github:danth/stylix/release-25.11";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      machines = [
        "nixstation"
        "nixtop"
        "nixbook"
        "nixserver"
        "nixvm"
        "nixmac"
	"nixtravel"
      ];

      mkNixosConfig =
        machine:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit unstable inputs outputs; };
          modules = [
            (./machines + "/${machine}.nix")
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            inputs.minegrub-theme.nixosModules.default
            inputs.noctalia.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.dan = import ./home-manager/home.nix;
                extraSpecialArgs = { inherit unstable inputs outputs; };
              };
            }
          ];
        };

    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (machine: {
          name = machine;
          value = mkNixosConfig machine;
        }) machines
      );
    };
}
