{
  description = "Standalone Home Manager configuration for OSS dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
      mkHomeConfiguration = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./home-manager/hosts/skalidindi.nix
            ./home-manager/modules/files.nix
            ./home-manager/modules/packages.nix
            ./home-manager/modules/programs.nix
          ];
        };
    in
    {
      homeConfigurations = {
        "oss-aarch64-darwin" = mkHomeConfiguration "aarch64-darwin";
        "oss-x86_64-darwin" = mkHomeConfiguration "x86_64-darwin";
      };

      packages = forAllSystems (system: {
        home-manager = home-manager.packages.${system}.home-manager;
      });

      checks = forAllSystems (system: {
        default = self.homeConfigurations."oss-${system}".activationPackage;
      });
    };
}
