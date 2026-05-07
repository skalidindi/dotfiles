# Nushell environment setup.

def --env prepend-path [path: string] {
    let expanded = ($path | path expand)

    if not ($expanded in $env.PATH) {
        $env.PATH = ($env.PATH | prepend $expanded)
    }
}

def --env prefer-path [path: string] {
    let expanded = ($path | path expand)

    $env.PATH = (
        $env.PATH
        | where { |entry| $entry != $expanded }
        | prepend $expanded
    )
}

def --env remove-path-fragment [fragment: string] {
    $env.PATH = ($env.PATH | where { |path| not ($path | str contains $fragment) })
}

def --env load-simple-env [file: path] {
    if not ($file | path exists) {
        return
    }

    let values = (
        open --raw $file
        | lines
        | each { |line| $line | str trim }
        | where { |line| ($line | is-not-empty) and not ($line | str starts-with "#") }
        | parse --regex '^(?:export\s+)?(?P<name>[A-Za-z_][A-Za-z0-9_]*)=(?P<value>.*)$'
        | reduce -f {} { |row, acc|
            let value = (
                $row.value
                | str trim
                | str trim --char '"'
                | str trim --char "'"
            )

            $acc | upsert $row.name $value
        }
    )

    load-env $values
}

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.NODE_REPL_HISTORY = ($nu.home-dir | path join ".node_history")
$env.NODE_REPL_HISTORY_SIZE = "32768"
$env.NODE_REPL_MODE = "sloppy"

$env.PYTHONIOENCODING = "UTF-8"
$env.HISTSIZE = "32768"
$env.HISTFILESIZE = $env.HISTSIZE
$env.HISTCONTROL = "ignoreboth"
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.BASH_SILENCE_DEPRECATION_WARNING = "1"
$env.HOMEBREW_AUTO_UPDATE_SECS = "86400"

$env.GPG_TTY = (try { ^tty | str trim } catch { "" })
$env.LS_COLORS = (try { ^vivid generate catppuccin-macchiato | str trim } catch { "" })

prepend-path ($nu.home-dir | path join "bin")
prepend-path "/opt/homebrew/bin"

if (which brew | is-not-empty) {
    let python_home = (
        try { [ (^brew --prefix python | str trim) "libexec" ] | path join } catch { "" }
    )

    if ($python_home | is-not-empty) {
        $env.PYTHON_HOME = $python_home
        prepend-path ($env.PYTHON_HOME | path join "bin")
    }
}

prepend-path ($nu.home-dir | path join "Library/Application Support/Coursier/bin")
prepend-path ($nu.home-dir | path join "istio-1.25.2/bin")
prepend-path ($nu.home-dir | path join "go/bin")
prepend-path ($nu.home-dir | path join ".cargo/bin")
prepend-path ($nu.home-dir | path join ".local/bin")
prepend-path "/usr/local/bin"
prepend-path "/usr/local/sbin"
prepend-path ($nu.home-dir | path join ".lmstudio/bin")

$env.BUN_INSTALL = ($nu.home-dir | path join ".bun")
prepend-path ($env.BUN_INSTALL | path join "bin")

$env.CODEX_HOME = ($nu.home-dir | path join ".codex")
$env.OPENAI_API_KEY = ($env.OPENAI_API_KEY? | default "dummy")

prepend-path ($nu.home-dir | path join ".npm-global/bin")

hide-env -i FNM_ARCH FNM_COREPACK_ENABLED FNM_DIR FNM_LOGLEVEL FNM_MULTISHELL_PATH FNM_NODE_DIST_MIRROR FNM_RESOLVE_ENGINES FNM_VERSION_FILE_STRATEGY PNPM_HOME
remove-path-fragment "/.local/state/fnm_multishells/"
remove-path-fragment "/.local/share/fnm/"
remove-path-fragment "/.local/share/pnpm"

$env.VOLTA_HOME = ($nu.home-dir | path join ".volta")
prepend-path ($env.VOLTA_HOME | path join "bin")

prepend-path ($nu.home-dir | path join ".antigravity/antigravity/bin")

load-simple-env ($nu.home-dir | path join ".env-secrets")

prefer-path ($nu.home-dir | path join ".local/bin")
