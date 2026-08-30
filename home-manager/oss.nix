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

  home.file.".aliases" = {
    source = ../bash/.aliases;
    force = true;
  };

  home.file.".bash_profile" = {
    source = ../bash/.bash_profile;
    force = true;
  };

  home.file.".exports" = {
    source = ../bash/.exports;
    force = true;
  };

  home.file.".functions" = {
    source = ../bash/.functions;
    force = true;
  };

  home.file.".path" = {
    source = ../bash/.path;
    force = true;
  };

  home.file.".zshrc" = {
    source = ../zsh/.zshrc;
    force = true;
  };

  home.file.".zsh_plugins.txt" = {
    source = ../zsh/.zsh_plugins.txt;
    force = true;
  };

  home.file.".zsh.d/_flamegraph" = {
    source = ../zsh/.zsh.d/_flamegraph;
    force = true;
  };

  home.file.".agents/README.md" = {
    source = ../agents/.agents/README.md;
    force = true;
  };

  home.file.".agents/prompts/base.md" = {
    source = ../agents/.agents/prompts/base.md;
    force = true;
  };

  home.file.".agents/prompts/pull-request.md" = {
    source = ../agents/.agents/prompts/pull-request.md;
    force = true;
  };

  home.file.".agents/skills.sh.sources.json" = {
    source = ../agents/.agents/skills.sh.sources.json;
    force = true;
  };

  xdg.configFile."git/.gitconfig.common" = {
    source = ../git/.config/git/.gitconfig.common;
    force = true;
  };

  xdg.configFile."git/.gitconfig.oss-base" = {
    source = ../git/.config/git/.gitconfig.oss-base;
    force = true;
  };

  xdg.configFile."git/.gitconfig.oss-laptop" = {
    source = ../git/.config/git/.gitconfig.oss-laptop;
    force = true;
  };

  xdg.configFile."git/ignore" = {
    source = ../git/.config/git/ignore;
    force = true;
  };

  xdg.configFile."git/template" = {
    source = ../git/.config/git/template;
    force = true;
  };
}
