#           ▜███▙       ▜███▙  ▟███▛
#            ▜███▙       ▜███▙▟███▛
#             ▜███▙       ▜██████▛
#      ▟█████████████████▙ ▜████▛     ▟▙
#     ▟███████████████████▙ ▜███▙    ▟██▙
#            ▄▄▄▄▖           ▜███▙  ▟███▛
#           ▟███▛             ▜██▛ ▟███▛
#          ▟███▛               ▜▛ ▟███▛
# ▟███████████▛                  ▟██████████▙
# ▜██████████▛                  ▟███████████▛
#       ▟███▛ ▟▙               ▟███▛
#      ▟███▛ ▟██▙             ▟███▛
#     ▟███▛  ▜███▙           ▝▀▀▀▀
#     ▜██▛    ▜███▙ ▜██████████████████▛
#      ▜▛     ▟████▙ ▜████████████████▛
#            ▟██████▙       ▜███▙
#           ▟███▛▜███▙       ▜███▙
#          ▟███▛  ▜███▙       ▜███▙
#          ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
#             Dan's Nixos Flake
# -------------------------------------------
#
{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    stylix.url = "github:danth/stylix/release-24.11";
    private.url = "git+file:///home/dan/.private";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # For Ardiunio
    ravedude.url = "github:Rahix/avr-hal?dir=ravedude";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    private,
    stylix,
    ghostty,
    ...
  } @ inputs: let inherit (self) outputs;

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    ravedude = ravedude.packages."${system}".default;

    unstableOverlay = {
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          };
        })
      ];
    };

  in {

    nixosConfigurations = {
      nixtop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
          ./machines/nixtop.nix
          home-manager.nixosModules.home-manager
          unstableOverlay
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
          }
        ];
      };
    };

    nixosConfigurations = {
      nixstation = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./machines/nixstation.nix
          home-manager.nixosModules.home-manager
          unstableOverlay
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
          }
        ];
      };
    };
  };
}
