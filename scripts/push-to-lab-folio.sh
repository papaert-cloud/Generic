#!/usr/bin/env bash
set -euo pipefail

# push-to-lab-folio.sh
# Push current branch to origin/lab-folio safely by default.

PUSH_REMOTE="${PUSH_REMOTE:-origin}"
PUSH_BRANCH="${PUSH_BRANCH:-lab-folio}"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "${CURRENT_BRANCH}" != "${PUSH_BRANCH}" ]; then
  echo "Warning: you are on '${CURRENT_BRANCH}', pushing to '${PUSH_BRANCH}' instead." >&2
  echo "Use FORCE_PUSH=1 to force pushing current branch as '${PUSH_BRANCH}'." >&2
  if [ "${FORCE_PUSH:-0}" != "1" ]; then
    exit 1
  fi
fi

git push "${PUSH_REMOTE}" "HEAD:${PUSH_BRANCH}"
echo "Pushed HEAD to ${PUSH_REMOTE}/${PUSH_BRANCH}"
