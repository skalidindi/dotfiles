#!/usr/bin/env bash

# Load Bash profiles
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Default editor for git
export EDITOR='atom -wn'

# .profile
if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi

export H5_BRANCH=h5c-main
if [[ "$H5_BRANCH" == "h5c-rel" ]]
then
   H5_DIR=h5_client_rel
   H5_SERVER_EXT=-rel
elif [[ "$H5_BRANCH" == "h5c-dev" ]]
then
   H5_DIR=h5_client_dev
   H5_SERVER_EXT=-dev
 elif [[ "$H5_BRANCH" == "h5c-main" ]]
 then
   H5_DIR=h5_client_main
   H5_SERVER_EXT=-main
else
   H5_DIR=h5_client
   H5_SERVER_EXT=''
fi

# H5
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

