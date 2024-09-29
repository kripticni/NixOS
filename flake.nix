{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        galahad = nixpkgs.lib.nixosSystem {
	specialArgs = {inherit inputs;};
          modules = [
            ./hosts/galahad/configuration.nix
	    inputs.home-manager.nixosModules.default
          ];
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
