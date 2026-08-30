{ lib, pkgs, ... }:

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

  home.file.".local/bin/agent-doctor" = {
    source = ../bin/.local/bin/agent-doctor;
    executable = true;
    force = true;
  };

  home.file.".local/bin/agent-runtime-guard" = {
    source = ../bin/.local/bin/agent-runtime-guard;
    executable = true;
    force = true;
  };

  home.file.".local/bin/configure-oss-git" = {
    source = ../bin/.local/bin/configure-oss-git;
    executable = true;
    force = true;
  };

  home.file.".local/bin/install-agent-assets" = {
    source = ../bin/.local/bin/install-agent-assets;
    executable = true;
    force = true;
  };

  home.file.".local/bin/restore-skills-sh" = {
    source = ../bin/.local/bin/restore-skills-sh;
    executable = true;
    force = true;
  };

  home.file.".local/bin/zrun" = {
    source = ../bin/.local/bin/zrun;
    executable = true;
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

  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
    extraConfig = builtins.readFile ../tmux/.config/tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      dracula
      vim-tmux-navigator
    ];
  };

  home.packages = [ pkgs.neovim ];

  home.file.".config/nvim/.gitignore" = {
    source = ../nvim/.config/nvim/.gitignore;
    force = true;
  };

  home.file.".config/nvim/.neoconf.json" = {
    source = ../nvim/.config/nvim/.neoconf.json;
    force = true;
  };

  home.file.".config/nvim/init.lua" = {
    source = ../nvim/.config/nvim/init.lua;
    force = true;
  };

  home.file.".config/nvim/lazyvim.json" = {
    source = ../nvim/.config/nvim/lazyvim.json;
    force = true;
  };

  home.file.".config/nvim/LICENSE" = {
    source = ../nvim/.config/nvim/LICENSE;
    force = true;
  };

  home.file.".config/nvim/README.md" = {
    source = ../nvim/.config/nvim/README.md;
    force = true;
  };

  home.file.".config/nvim/stylua.toml" = {
    source = ../nvim/.config/nvim/stylua.toml;
    force = true;
  };

  home.file.".config/nvim/lua/config/autocmds.lua" = {
    source = ../nvim/.config/nvim/lua/config/autocmds.lua;
    force = true;
  };

  home.file.".config/nvim/lua/config/keymaps.lua" = {
    source = ../nvim/.config/nvim/lua/config/keymaps.lua;
    force = true;
  };

  home.file.".config/nvim/lua/config/lazy.lua" = {
    source = ../nvim/.config/nvim/lua/config/lazy.lua;
    force = true;
  };

  home.file.".config/nvim/lua/config/options.lua" = {
    source = ../nvim/.config/nvim/lua/config/options.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/bufferline.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/bufferline.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/colorscheme.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/colorscheme.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/dashboard.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/dashboard.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/helpview.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/helpview.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/treesj.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/treesj.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/typing.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/typing.lua;
    force = true;
  };

  home.file.".config/nvim/lua/plugins/yazi.lua" = {
    source = ../nvim/.config/nvim/lua/plugins/yazi.lua;
    force = true;
  };

  home.activation.nvimLazyLock = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    lock="$HOME/.config/nvim/lazy-lock.json"
    if [ ! -e "$lock" ]; then
      cp ${../nvim/.config/nvim/lazy-lock.json} "$lock"
    fi
  '';
}
