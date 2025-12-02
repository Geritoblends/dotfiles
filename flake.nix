{
  description = "Local and Remote nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # --- THE FIX IS HERE ---
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        "local" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./common.nix 
            ./hosts/local.nix 
          ];
        };

        "remote" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./common.nix 
            ./hosts/remote.nix 
          ];
        };
      };
    };
}
