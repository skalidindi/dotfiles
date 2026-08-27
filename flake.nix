{
  description = "Opt-in OSS development environment for dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          });
    in
    {
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
              git-delta
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
