1.) Inspect local branch, remotes, and status:
git branch --show-current
git branch -vv
git remote -v
git status -sb
2.) Fetch + inspect commit differences:
git fetch origin
git log --oneline --graph --decorate --left-right --boundary origin/docs-reorg...docs-reorg
3.) Rebased your local commit on top of origin/docs-reorg so we integrate the remote changes cleanly:
git pull --rebase origin docs-reorg
4.) Set upstream and push:
git push --set-upstream origin docs-reorg
5.) Current state (verification)
git branch -vv
git remote show origin

Note: If the remote branch is protected (prevents force-pushes):

1. Don't force-push. Rebase locally only if your team allows rebases; otherwise git merge origin/docs-reorg and then git push.

2. If you prefer to avoid rebase and keep history with merges:
Use git pull --no-rebase origin docs-reorg (or just git pull) and then git push.

    Merge-based alternative to rebase (walkthrough) If your team prefers merges (preserves merge commits and avoids rewriting public history), use this flow instead of rebasing.

   1.) Fetch origin:
    git fetch origin

    2.) Merge remote branch into your local branch:
    # Make sure you're on docs-reorg
    git checkout docs-reorg

    # Merge origin/docs-reorg into local branch
    git merge origin/docs-reorg

    3.) Push (upstream already set)
    git push