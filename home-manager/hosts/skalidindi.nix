{ config, lib, pkgs, ... }:

{
  home.username = "skalidindi";
  home.homeDirectory = lib.mkDefault "/Users/${config.home.username}";
  home.stateVersion = "25.11";

  xdg.configFile."git/.gitconfig.oss-base".text = ''
    [user]
      name = Santosh Kalidindi
      initials = sk
      email = skalidindi8@gmail.com
      signingKey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILStz8inUx8fxRsyC0YCILnXJlgTDc24tyiGenJJQHXY

    [commit]
      gpgsign = true

    [gpg]
      format = ssh

    [gpg "ssh"]
      allowedSignersFile = ${config.xdg.configHome}/git/allowed_signers
    ${lib.optionalString pkgs.stdenv.isDarwin ''
      program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
    ''}
  '';

  xdg.configFile."git/allowed_signers".text = ''
    skalidindi8@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILStz8inUx8fxRsyC0YCILnXJlgTDc24tyiGenJJQHXY
  '';

  xdg.configFile."git/.gitconfig.oss-laptop".text = ''
    [includeIf "gitdir:${config.home.homeDirectory}/oss/"]
      path = ${config.home.homeDirectory}/.config/git/.gitconfig.oss-base
  '';
}
