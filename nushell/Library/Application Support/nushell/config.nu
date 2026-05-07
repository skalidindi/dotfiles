# Nushell interactive configuration.

$env.config = ($env.config? | default {})
$env.config.show_banner = false
$env.config.edit_mode = "emacs"
$env.config.buffer_editor = "nvim"
$env.config.history = (
    $env.config.history?
    | default {}
    | merge {
        file_format: "sqlite"
        max_size: 32768
        isolation: true
    }
)

const starship_init = ($nu.default-config-dir | path join "vendor/starship.nu")
const atuin_init = ($nu.default-config-dir | path join "vendor/atuin.nu")
const zoxide_init = ($nu.default-config-dir | path join "vendor/zoxide.nu")
const jj_completion = ($nu.default-config-dir | path join "completions/jj.nu")

source $starship_init
source $atuin_init
source $zoxide_init
use $jj_completion *

alias nu-open = open
alias open = ^open

alias doc = cd ~/Documents
alias desk = cd ~/Desktop

alias la = ^eza --icons -a
alias ll = ^eza --icons --long --header --git
alias lt = ^eza --tree --level=4 -I=.git --git-ignore

alias vim = nvim
alias vi = nvim
alias cat = ^bat --style=plain

alias codex = ^agent-awake codex
alias claude = ^agent-awake claude

alias g = ^git
alias ga = ^git add
alias gca = ^git commit -a
alias gb = ^git branch
alias gc = ^git commit
alias gcl = ^git clone
alias gcf = ^git commit --fixup
alias gd = ^git diff
alias gl = ^git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"
alias gp = ^git push
alias gpf = ^git push --force-with-lease --force-if-includes
alias grf = ^git reflog
alias gst = ^git status
alias gsw = ^git switch
alias gu = ^git pull

alias lg = ^lazygit

def --wrapped sh [...args] {
    with-env { SHELL: "/bin/zsh" } {
        ^zsh -fc ($args | str join " ")
    }
}

def path-list [] {
    $env.PATH
}

def week [] {
    date now | format date "%V"
}

def c [] {
    $in | str join "" | ^pbcopy
}

def v [] {
    let file = (
        ^fd --type f --hidden --exclude .git
        | ^fzf --preview "bat --style numbers,changes --color=always {}"
        | str trim
    )

    if ($file | is-not-empty) {
        ^nvim $file
    }
}

def gcb [] {
    let branch = (
        ^git branch --sort=-committerdate --format="%(refname:short)"
        | ^fzf --header Checkout
        | str trim
    )

    if ($branch | is-not-empty) {
        ^git checkout $branch
    }
}

def reset_vpn [] {
    let pid = (^pgrep -f dsAccessService | lines | first)

    if ($pid | is-not-empty) {
        ^sudo kill -SEGV $pid
    }

    ^sudo route delete pcs.flxvpn.net
}

def get_ip [] {
    ^ipconfig getifaddr en0 | ^pbcopy
}

def fs [...paths: path] {
    if ($paths | is-empty) {
        ^du -sh .
    } else {
        ^du -sh ...$paths
    }
}

def gz [file: path] {
    let orig_size = (^wc -c $file | str trim | split row --regex '\s+' | first | into int)
    let gzip_size = (^gzip -c $file | ^wc -c | str trim | into int)
    let ratio = ($gzip_size * 100 / $orig_size)

    print $"orig: ($orig_size) bytes"
    print $"gzip: ($gzip_size) bytes (($ratio | math round --precision 2)%)"
}

def online [] {
    let result = (^ping -c 1 1.1.1.1 | complete)

    if $result.exit_code == 0 {
        print "ok"
    } else {
        print "fail"
    }
}

def killport [port: int] {
    ^lsof -t -i $"tcp:($port)"
    | lines
    | each { |pid| ^kill -9 $pid }
    | ignore
}

def --env y [...args: string] {
    let tmp = (^mktemp -t "yazi-cwd.XXXXXX" | str trim)
    ^yazi ...$args --cwd-file $tmp

    let cwd = (open --raw $tmp | str trim)

    if ($cwd | is-not-empty) and ($cwd != $env.PWD) {
        cd $cwd
    }

    rm -f $tmp
}

def --env zellij_sessionizer [] {
    let selection = (^zellij-sessionizer --select-dir | complete)

    if $selection.exit_code != 0 {
        return
    }

    let selected_dir = ($selection.stdout | str trim)

    if ($selected_dir | is-empty) {
        return
    }

    let session_name = (^zellij-sessionizer --session-name-for-dir $selected_dir | str trim)

    if ($env.ZELLIJ? | is-not-empty) {
        ^zellij action switch-session --cwd $selected_dir $session_name
    } else {
        cd $selected_dir
        ^agent-awake zellij attach $session_name --create
    }
}

$env.config.keybindings = (
    $env.config.keybindings?
    | default []
    | append {
        name: zellij_sessionizer
        modifier: control
        keycode: char_f
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "zellij_sessionizer" }
    }
)
