{
  xdg.configFile = {
    "starship.toml" = {
      source = ../../config/starship/starship.toml;
      force = true;
    };

    "zellij" = {
      source = ../../config/zellij;
      recursive = true;
      force = true;
    };

    "yazi" = {
      source = ../../config/yazi;
      recursive = true;
      force = true;
    };

    "fastfetch" = {
      source = ../../config/fastfetch;
      recursive = true;
      force = true;
    };

    "ghostty" = {
      source = ../../config/ghostty;
      recursive = true;
      force = true;
    };

    "lazygit" = {
      source = ../../config/lazygit;
      recursive = true;
      force = true;
    };

    "herdr" = {
      source = ../../config/herdr;
      recursive = true;
      force = true;
    };

    "worktrunk" = {
      source = ../../config/worktrunk;
      recursive = true;
      force = true;
    };

    "git/.gitconfig.common" = {
      source = ../../config/git/.gitconfig.common;
      force = true;
    };

    "git/ignore" = {
      source = ../../config/git/ignore;
      force = true;
    };
  };

  home.file = {
    ".aliases" = {
      source = ../../config/bash/.aliases;
      force = true;
    };

    ".bash_profile" = {
      source = ../../config/bash/.bash_profile;
      force = true;
    };

    ".exports" = {
      source = ../../config/bash/.exports;
      force = true;
    };

    ".functions" = {
      source = ../../config/bash/.functions;
      force = true;
    };

    ".path" = {
      source = ../../config/bash/.path;
      force = true;
    };

    ".zshrc" = {
      source = ../../config/zsh/.zshrc;
      force = true;
    };

    ".zsh_plugins.txt" = {
      source = ../../config/zsh/.zsh_plugins.txt;
      force = true;
    };

    ".zsh.d/_flamegraph" = {
      source = ../../config/zsh/.zsh.d/_flamegraph;
      force = true;
    };

    ".agents" = {
      source = ../../config/agents;
      recursive = true;
      force = true;
    };

    ".local/bin/agent-doctor" = {
      source = ../../scripts/bin/agent-doctor;
      executable = true;
      force = true;
    };

    ".local/bin/agent-runtime-guard" = {
      source = ../../scripts/bin/agent-runtime-guard;
      executable = true;
      force = true;
    };

    ".local/bin/configure-oss-git" = {
      source = ../../scripts/bin/configure-oss-git;
      executable = true;
      force = true;
    };

    ".local/bin/install-agent-assets" = {
      source = ../../scripts/bin/install-agent-assets;
      executable = true;
      force = true;
    };

    ".local/bin/restore-skills-sh" = {
      source = ../../scripts/bin/restore-skills-sh;
      executable = true;
      force = true;
    };

    ".local/bin/zrun" = {
      source = ../../scripts/bin/zrun;
      executable = true;
      force = true;
    };
  };
}
