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
const zoxide_init = ($nu.default-config-dir | path join "vendor/zoxide.nu")
const jj_completion = ($nu.default-config-dir | path join "completions/jj.nu")

source $starship_init
source $zoxide_init
use $jj_completion *

source ~/.config/dotfiles/shell/work.nu

# keep nushell's builtin `open` (used by vendor autoloads like wt.nu, and `def y`);
# launch macOS apps/URLs with `oo`
alias oo = ^open

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

# Agent launchers can exec versioned binaries, which prevents Herdr from
# recognizing them by process name. Keep its documented hint scoped to each
# launcher instead of exporting it for the entire shell.
def --wrapped claude [...args] {
    with-env { HERDR_AGENT: "claude" } {
        ^claude ...$args
    }
}

def --wrapped codex [...args] {
    with-env { HERDR_AGENT: "codex" } {
        ^codex ...$args
    }
}

def codex-pr-netflix [] {
    let state = ($nu.home-dir | path join ".codex" ".codex-global-state.json")
    if not ($state | path exists) {
        error make { msg: $"Codex state file not found: ($state)" }
    }

    let running = (^osascript -e 'application id "com.openai.codex" is running' | str trim)
    if $running == "true" {
        let quit = (
            ^osascript -e 'tell application id "com.openai.codex" to quit'
            | complete
        )
        if $quit.exit_code != 0 {
            error make { msg: $"Failed to quit Codex: ($quit.stderr | str trim)" }
        }

        mut attempts = 0
        while $attempts < 50 {
            let still_running = (^osascript -e 'application id "com.openai.codex" is running' | str trim)
            if $still_running != "true" {
                break
            }
            sleep 100ms
            $attempts += 1
        }

        let still_running = (^osascript -e 'application id "com.openai.codex" is running' | str trim)
        if $still_running == "true" {
            error make { msg: "Codex did not quit within 5 seconds" }
        }
    }

    let stamp = (date now | format date "%Y%m%d-%H%M%S")
    let backup = $"($state).bak-($stamp)"
    let updated = (
        ^jq '."electron-persisted-atom-state"."pull-request-last-account" = {"hostId":"local","hostname":"github.netflix.net","login":"skalidindi"}' $state
        | complete
    )

    if $updated.exit_code != 0 {
        error make { msg: $"Failed to update Codex state: ($updated.stderr | str trim)" }
    }

    cp $state $backup
    $updated.stdout | save --force $"($state).new"
    mv --force $"($state).new" $state

    ^open -a ChatGPT
    print $"Configured Codex Pull requests for github.netflix.net and reopened Codex. Backup: ($backup)"
}

alias cpr = codex-pr-netflix

def --wrapped pi [...args] {
    with-env { HERDR_AGENT: "pi" } {
        ^pi ...$args
    }
}

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

# >>> work-dotfiles generated vendor scripts >>>
source vendor/00-homebrew.nu
source vendor/starship.nu
source vendor/zoxide.nu
source vendor/worktrunk.nu
# <<< work-dotfiles generated vendor scripts <<<
