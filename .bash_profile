#!/usr/bin/env bash
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Updates
alias brewup='brew update && brew upgrade && brew prune && brew cleanup && brew cask cleanup; brew doctor'
alias nodeup='npm outdated --global && npm update -g'
alias gemup='gem update'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias d="cd ~/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"
alias g="git"
alias h="history"
alias j="jobs"

# Enable aliases to be sudo’ed
#alias sudo='sudo '

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

# Git shortcuts
alias gst='git status'
alias gb='git branch'
alias gp='git pull'

alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'

# Default editor for git
export EDITOR='atom -wn'

# .profile
if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi

# H5
alias v='cd ~/workspace/$H5_DIR'
alias vc='cd ~/workspace/$H5_DIR/vim-clients'
alias vcm='cd ~/workspace/$H5_DIR/vsphere-client-modules'
alias vui='cd ~/workspace/h5_client/vui-components'
alias cui='cd ~/workspace/vsphere-client-config-ui'
alias resprout='(cd ~/workspace/sprout-vmwareh5 && git pull && bundle exec soloist)'
alias updatecfg='source ~/.bash_profile'

export H5_BRANCH=vmkernel-main
if [[ "$H5_BRANCH" == "h5c-rel" ]]
then
   H5_DIR=h5_client_rel
   H5_SERVER_EXT=-rel
elif [[ "$H5_BRANCH" == "h5c-dev" ]]
then
   H5_DIR=h5_client_dev
   H5_SERVER_EXT=-dev
else
   H5_DIR=h5_client
   H5_SERVER_EXT=''
fi

export M2=${M2_HOME}/bin
export MAVEN_OPTS="-Xmx4352m -Xms512m -XX:PermSize=128m -XX:MaxPermSize=512m -Dorg.slf4j.simpleLogger.showThreadName=true -Dorg.slf4j.simpleLogger.showDateTime=true"
export TCROOT=${HOME}/workspace/toolchain
export BUILDAPPSROOT=${HOME}/workspace/apps
export BUILDAPPS=${BUILDAPPSROOT}/bin
export P4CONFIG=.p4config
export H5_CLIENT=${HOME}/workspace/devServers${H5_SERVER_EXT}/h5-client
export VMWARE_CFG_DIR=/var/lib/vmware/vsphere-client

H5_CLI=${HOME}/workspace/${H5_DIR}/vim-clients/cli
VM_CLI=${HOME}/workspace/${H5_DIR}/vsphere-client-modules/h5-plugin/ui/vm-ui/cli

export PATH=${H5_CLI}:${VM_CLI}:${PATH}:${M2}:${BUILDAPPS}

