{ config, lib, ... }:

{
  home.username = "skalidindi";
  home.homeDirectory = lib.mkDefault "/Users/${config.home.username}";
  home.stateVersion = "25.11";

  xdg.configFile."git/.gitconfig.oss-base".text = ''
    [user]
      name = Santosh Kalidindi
      initials = sk
      email = skalidindi8@gmail.com
      signingKey = 5EFA48B9657D7C02

    [commit]
      gpgsign = true
  '';

  xdg.configFile."git/.gitconfig.oss-laptop".text = ''
    [includeIf "gitdir:${config.home.homeDirectory}/oss/"]
      path = ${config.home.homeDirectory}/.config/git/.gitconfig.oss-base
  '';
}
