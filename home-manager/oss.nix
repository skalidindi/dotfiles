{ ... }:

{
  # This profile is intentionally limited to the first migrated OSS config.
  # Homebrew continues to own the starship executable for now.
  home.username = "skalidindi";
  home.homeDirectory = "/Users/skalidindi";
  home.stateVersion = "25.11";

  xdg.configFile."starship.toml" = {
    source = ../starship/.config/starship.toml;
    # Replace the legacy Stow link during this one-time ownership migration.
    force = true;
  };
}
