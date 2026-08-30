{ ... }:

{
  home.stateVersion = "25.11";

  xdg.configFile."starship.toml" = {
    source = ../starship/.config/starship.toml;
    force = true;
  };

  xdg.configFile."zellij" = {
    source = ../zellij/.config/zellij;
    force = true;
  };

  xdg.configFile."yazi" = {
    source = ../yazi/.config/yazi;
    force = true;
  };
}
