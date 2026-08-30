{ config, ... }:

{
  home.username = "skalidindi";
  home.homeDirectory = "/Users/${config.home.username}";
}
