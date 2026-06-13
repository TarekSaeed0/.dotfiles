#!/bin/zsh

setopt AUTO_PUSHD
setopt CD_SILENT
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT

function cd() {
  if [[ "$1" == "--" ]]; then
    dirs -v
    return 0
  fi

  builtin cd "$@"
}
