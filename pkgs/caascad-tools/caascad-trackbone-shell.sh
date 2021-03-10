#!/usr/bin/env bash

set -euo pipefail

CAASCAD_TRACKBONE_SHELL_TRACE=${CAASCAD_TRACKBONE_SHELL_TRACE:-0}
if [ "${CAASCAD_TRACKBONE_SHELL_TRACE}" -eq 1 ]; then set -x; fi

ENVS="git@git.corp.cloudwatt.com:caascad/terraform/envs-ng.git"

function generate () {
  TMP_DIR=$(mktemp -d)
  mkdir -p "${TMP_DIR}"
  (
    cd "${TMP_DIR}"
    git clone "${ENVS}" .
    nix-shell
  )
  
  rm -rf "${TMP_DIR}"
}

function purge () {
  rm -rf /run/user/$(id -u)/{trackbone,nix-shell}-*
}

function _help () {
  cat <<EOF
NAME
      Helper that provides a temporaty envs-ng sync with  master for trackbone operations

SYNOPSIS 
      caascad-trackbone-shell <ACTION>

      ACTION:

      generate, g
            clone the envs-ng into a temporary directory and starts nix-shell. The temp dir will be removed after nix-shell exit.

      purge, p
            purges all temp directories generated by trackbone shell commands

      -h, --help
            Display this help 
 
EXAMPLES

      $ caascad-trackbone-shell generate

      $ CAASCAD_TRACKBONE_SHELL_TRACE=1 caascad-trackbone-shell purge
EOF

}

if [ "$#" -ne 1 ]; then _help; exit 1; fi

case "${1}" in
  -h|--help)
    _help;;
  generate|g)
    generate;;
  purge|p)
    purge;;
esac

