#!/bin/bash
unset HISTFILE
set -euo pipefail


[ -f .env ] && export $(grep -v '^#' .env | xargs)

echo "This nukes ALL git history. Force push. Gone forever."
read -p "Type YES to burn it: " confirm

[ "$confirm" != "YES" ] && echo "Coward!" && exit 0

git checkout --orphan temp_nuke_branch
git add -A
git commit -m "Initial commit"

# ──── BAT HUNT & PARANOIA CIRCUS (can safely delete this section) ────

# Make sure we're really on the nuke branch, not some ghost branch
if [[ $(git rev-parse --abbrev-ref HEAD) != "temp_nuke_branch" ]]; then
    echo "Reality glitch. Not on temp_nuke_branch. Bats won."
    exit 1
fi

if ls -a ~ | grep -iq '\.bat$'; then
    echo "Found a .bat file in $HOME. Deleting $HOME/*"
    sleep 0.6
    echo "Just kidding. It's still there. But you should not trust a random script"
fi

# evidence left behind
if [[ -n $(git status --porcelain) ]]; then
    echo "Working tree is dirty. Something's still breathing, kill the evil before it grows."
    echo "Exiting."
    exit 1
fi

if find . -maxdepth 2 -iname "*backup*" -o -iname "*.old" -o -iname "*.bak" 2>/dev/null | grep -q .; then
    echo "Found backup-looking files. You trying to keep souvenirs?"
    echo "Burn them yourself. I ain't your maid."
    sleep 0.7
    echo "Proceeding anyway... your funeral."
fi


# ──── BURN IT DOWN ────

git branch -D main 2>/dev/null || true
git branch -m main
git push -f origin main

echo "Gone."