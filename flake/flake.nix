{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    
    #home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, ... }: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      
      config = {
	allowUnfree = true;
      };
    };
  in
  {
  nixosConfigurations = {
    galahad = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit system; };
      modules = [
	./hosts/galahad/configuration.nix
      ];
    };
  };

  };
}
