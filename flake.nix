{
  description = "Opt-in OSS development environment for dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          });
      homeConfigurationsBySystem = nixpkgs.lib.genAttrs systems (system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./home-manager/oss.nix
            ./home-manager/hosts/skalidindi.nix
          ];
        });
      homeConfigurationsByName = builtins.listToAttrs (map (system: {
        name = "oss-${system}";
        value = homeConfigurationsBySystem.${system};
      }) systems);
    in
    {
      homeConfigurations = homeConfigurationsByName // {
        oss = homeConfigurationsBySystem.aarch64-darwin;
      };

      packages = forAllSystems ({ system, ... }:
        {
          home-manager = home-manager.packages.${system}.home-manager;
        });

      devShells = forAllSystems ({ pkgs, ... }:
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              bat
              cargo
              curl
              eza
              fd
              fzf
              git
              delta
              jq
              neovim
              nodejs
              python3
              ripgrep
              rustc
              starship
              stow
              tree-sitter
              uv
              wget
              yazi
              zellij
              zoxide
            ];
          };
        });

      checks = forAllSystems ({ system, ... }:
        {
          default = self.devShells.${system}.default;
        });
    };
}
