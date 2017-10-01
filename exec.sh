#!/usr/bin/env bash

set -e

. /opam/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval `opam config env`

exec "$@"
