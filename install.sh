#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

printf '%s\n' "install.sh now delegates to the interactive macOS setup."
exec "${REPO_ROOT}/setup" "$@"
