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

  xdg.configFile."fastfetch" = {
    source = ../fastfetch/.config/fastfetch;
    force = true;
  };

  xdg.configFile."ghostty" = {
    source = ../ghostty/.config/ghostty;
    force = true;
  };

  xdg.configFile."lazygit" = {
    source = ../lazygit/.config/lazygit;
    force = true;
  };

  xdg.configFile."herdr/config.toml" = {
    source = ../herdr/.config/herdr/config.toml;
    force = true;
  };

  xdg.configFile."worktrunk/config.toml" = {
    source = ../worktrunk/.config/worktrunk/config.toml;
    force = true;
  };
}
