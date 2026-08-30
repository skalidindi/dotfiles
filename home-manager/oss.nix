{ ... }:

{
  home.stateVersion = "25.11";

  xdg.configFile."starship.toml" = {
    source = ../starship/.config/starship.toml;
    force = true;
  };
}
