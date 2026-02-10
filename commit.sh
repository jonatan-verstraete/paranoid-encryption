#!/usr/bin/env bash

unset HISTFILE
set -euo pipefail

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Error: .env file not found"
  exit 1
fi


bash encrypt.sh


git add "$ENCRYPTED_FILE"
git commit -m "###"

if git log -1 --pretty=%B | grep -qi "bat"; then
    echo "BATS DETECTED IN COMMIT MESSAGE. Abort the ship."
    exit 1
fi

git push origin main || git push origin master || echo "Edit your paranoid branch names!"