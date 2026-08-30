{ config, ... }:

{
  system.primaryUser = "skalidindi";
  users.users.${config.system.primaryUser}.home = "/Users/${config.system.primaryUser}";
  system.stateVersion = 6;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
