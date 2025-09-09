#!/usr/bin/env bash
set -euo pipefail

# commit-and-push.sh
# Helper to do safe commits and optional automatic push to origin/lab-folio.
# Usage: ./scripts/commit-and-push.sh -m "commit message"

REPO_ROOT="$(git rev-parse --show-toplevel)" # repo root
# default remote/branch targets
PUSH_REMOTE="${PUSH_REMOTE:-origin}"
PUSH_BRANCH="${PUSH_BRANCH:-lab-folio}"
# AUTO_PUSH=1 to enable automatic pushes after a successful commit
# NOTE: default AUTO_PUSH is enabled for this environment; set AUTO_PUSH=0 to disable
AUTO_PUSH="${AUTO_PUSH:-1}"
# FORCE_ALLOW=1 to allow committing on branches other than lab-folio (use with caution)
FORCE_ALLOW="${FORCE_ALLOW:-0}"

usage() {
  echo "Usage: $0 -m 'commit message'"
  echo "Environment variables: AUTO_PUSH=1 to auto-push, FORCE_ALLOW=1 to bypass branch enforcement"
  exit 2
}

MSG=""
while getopts ":m:" opt; do
  case ${opt} in
    m) MSG=${OPTARG} ;;
    *) usage ;;
  esac
done

if [ -z "${MSG}" ]; then
  usage
fi

# Ensure we're inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "${CURRENT_BRANCH}" != "${PUSH_BRANCH}" ] && [ "${FORCE_ALLOW}" != "1" ]; then
  echo "Refusing to commit on branch '${CURRENT_BRANCH}'." >&2
  echo "All commits should go to '${PUSH_BRANCH}'." >&2
  echo "Set FORCE_ALLOW=1 to bypass (not recommended)." >&2
  exit 1
fi

# Stage everything (you can change to a more granular add if desired)
git add -A

# Commit
git commit -m "$MSG" || {
  echo "No changes to commit or commit failed." >&2
  exit 1
}

echo "Committed on ${CURRENT_BRANCH}."

if [ "${AUTO_PUSH}" = "1" ]; then
  # Hint to user that an automatic push is about to occur
  echo "[hint] AUTO_PUSH=1 (default) — automatically pushing commit to ${PUSH_REMOTE}/${PUSH_BRANCH}"
  echo "[hint] To disable auto-push for this run: run with AUTO_PUSH=0"
  git push "${PUSH_REMOTE}" "HEAD:${PUSH_BRANCH}"
  echo "Push complete."
else
  echo "AUTO_PUSH not enabled. To push now: git push ${PUSH_REMOTE} ${PUSH_BRANCH}"
  echo "Or run: ./scripts/push-to-lab-folio.sh"
fi
