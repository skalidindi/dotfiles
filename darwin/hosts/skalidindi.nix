{ config, self, ... }:

{
  system.primaryUser = "skalidindi";
  users.users.${config.system.primaryUser}.home = "/Users/${config.system.primaryUser}";
  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
