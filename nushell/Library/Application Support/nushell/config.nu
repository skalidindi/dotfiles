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

def ghrepo [...args: string] {
    if (".git" | path exists) {
        ^gh -R $"corp/($env.PWD | path basename)" ...$args
    } else {
        ^gh ...$args
    }
}

def lm [] {
    ^metatron curl -a copilotcp "https://copilotcp.vip.us-east-1.prod.cloud.netflix.net:8443/models/list_models" -H "accept: application/json"
    | from json
    | get models
    | each { |model| $"($model.id) \(context size: ($model.contextSize)\)" }
}

$env.config = (
    $env.config
    | upsert hooks { default {} }
    | upsert hooks.env_change { default {} }
    | upsert hooks.env_change.PWD { default [] }
)

$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD
    | append {|_, _|
        if (which fnm | is-not-empty) and ([ ".node-version" ".nvmrc" "package.json" ] | any { |file| $file | path exists }) {
            ^fnm use --silent-if-unchanged | ignore
        }
    }
)

$env.config.keybindings = (
    $env.config.keybindings?
    | default []
    | append {
        name: tmux_sessionizer
        modifier: control
        keycode: char_f
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "tmux-sessionizer" }
    }
)
