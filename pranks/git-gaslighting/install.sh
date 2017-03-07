#! /usr/bin/env bash

set -u

GIT_PATH=$(which git)
EMPTY_REPO_PATH="/tmp/shellpranks/gas-git"
SCRIPT_LOC=$(dirname $0)

function setup_empty_repo {
    local parent=$(dirname "$1")
    mkdir -p "$parent"
    cp -r "$SCRIPT_LOC/empty-git-repo" "$1"
    mv "$SCRIPT_LOC/empty-git-repo/git" "$SCRIPT_LOC/empty-git-repo/.git"
}

function run_in_empty_repo {
    local args=$@
    if [ $# -eq 0 ]; then
       args="help"
    fi 

    sh -c "cd '$EMPTY_REPO_PATH' && '$GIT_PATH' $args"
}

function gas_git {
    local dice_roll=$(( ( RANDOM % 10 )  + 1 ))
    if [ $dice_roll -le 2 ]; then
        run_in_empty_repo $@
    else
        "$GIT_PATH" $@
    fi
}

setup_empty_repo "$EMPTY_REPO_PATH" || true
unalias git 2> /dev/null || true
alias git=gas_git


## oh-my-zsh fixes
export DISABLE_UNTRACKED_FILES_DIRTY=1
