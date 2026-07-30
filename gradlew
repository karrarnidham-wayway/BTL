#!/usr/bin/env bash
set -euo pipefail

if ! command -v gradle >/dev/null 2>&1; then
  echo "gradle command not found on this build machine."
  exit 1
fi

exec gradle "$@"
