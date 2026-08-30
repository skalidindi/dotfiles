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
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
      homeModules = [
        ./home-manager/hosts/skalidindi.nix
        ./home-manager/modules/files.nix
        ./home-manager/modules/packages.nix
        ./home-manager/modules/programs.nix
      ];
      mkHomeConfiguration = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = homeModules;
        };
      mkDarwinConfiguration = system:
        nix-darwin.lib.darwinSystem {
          inherit system;
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
        "oss-aarch64-darwin" = mkHomeConfiguration "aarch64-darwin";
        "oss-x86_64-darwin" = mkHomeConfiguration "x86_64-darwin";
      };

      darwinConfigurations = {
        "oss-aarch64-darwin" = mkDarwinConfiguration "aarch64-darwin";
        "oss-x86_64-darwin" = mkDarwinConfiguration "x86_64-darwin";
      };

      packages = forAllSystems (system: {
        darwin-rebuild = nix-darwin.packages.${system}.darwin-rebuild;
        home-manager = home-manager.packages.${system}.home-manager;
      });

      checks = forAllSystems (system: {
        default = self.darwinConfigurations."oss-${system}".system;
      });
    };
}
