{
  description = "Standalone Home Manager configuration for OSS dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-darwin = {
    url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
      homeModules = [
        ./home-manager/hosts/skalidindi.nix
        ./home-manager/modules/files.nix
        ./home-manager/modules/packages.nix
        ./home-manager/modules/programs.nix
      ];
      mkHomeConfiguration = { system, homeDirectory }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = homeModules ++ [{ home.homeDirectory = homeDirectory; }];
        };
      mkDarwinConfiguration = system:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit self; };
          modules = [
            ./darwin/hosts/skalidindi.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.skalidindi = {
                imports = homeModules;
              };
            }
          ];
        };
    in
    {
      # Evaluation only; darwin-rebuild is the system activation path.
      homeConfigurations = {
        "oss-aarch64-darwin" = mkHomeConfiguration {
          system = "aarch64-darwin";
          homeDirectory = "/Users/skalidindi";
        };
        "oss-x86_64-linux" = mkHomeConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/skalidindi";
        };
      };

      darwinConfigurations = {
        "oss-aarch64-darwin" = mkDarwinConfiguration "aarch64-darwin";
      };

      packages = {
        aarch64-darwin = {
          darwin-rebuild = nix-darwin.packages.aarch64-darwin.darwin-rebuild;
          home-manager = home-manager.packages.aarch64-darwin.home-manager;
        };
        x86_64-linux = {
          home-manager = home-manager.packages.x86_64-linux.home-manager;
        };
      };

      checks = forAllSystems (system: {
        default = if system == "aarch64-darwin"
          then self.darwinConfigurations."oss-${system}".system
          else self.homeConfigurations."oss-${system}".activationPackage;
      });
    };
}
