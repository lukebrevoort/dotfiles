#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

printf '%s\n' "bootstrap.sh is retained for compatibility."
printf '%s\n' "Delegating to the profile-aware setup without package installation."

exec "${REPO_ROOT}/setup" --skip-packages "$@"
