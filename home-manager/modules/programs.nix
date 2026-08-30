{ lib, pkgs, ... }:

let
  nvimConfig = lib.cleanSourceWith {
    src = ../../config/nvim;
    filter = path: type:
      type == "directory" || builtins.baseNameOf path != "lazy-lock.json";
  };
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
    extraConfig = builtins.readFile ../../config/tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      dracula
      vim-tmux-navigator
    ];
  };

  xdg.configFile."nvim" = {
    source = nvimConfig;
    recursive = true;
    force = true;
  };

  home.activation.nvimLazyLock = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    lock="$HOME/.config/nvim/lazy-lock.json"
    if [ ! -e "$lock" ]; then
      ${pkgs.coreutils}/bin/install -m 0644 ${../../config/nvim/lazy-lock.json} "$lock"
    else
      ${pkgs.coreutils}/bin/chmod u+w "$lock"
    fi
  '';
}
