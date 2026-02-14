{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, noctalia, home-manager,... }: {
	nixosConfigurations.victuu = nixpkgs.lib.nixosSystem {
		specialArgs = { inherit inputs; };
		modules = [
			    ./configuration.nix
	                    home-manager.nixosModules.home-manager
          			{
            			home-manager.useGlobalPkgs = true;
            			home-manager.useUserPackages = true;
				home-manager.backupFileExtension = "backup";
            			home-manager.users.sumit = ./home.nix;

          }
				];
	};

  };
}
