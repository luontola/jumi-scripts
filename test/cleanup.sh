#!/bin/bash
set -eu

if [[ `basename $PWD` != "dummy-project" ]]
then
    echo "Cannot run in $PWD"
    exit 1
fi

# Remove the dummy keys used for signing
gpg --batch --delete-secret-keys "D9043920AF8818F44D4D2C2A5D9ADEA0E55E2B08" || true
gpg --batch --delete-keys "D9043920AF8818F44D4D2C2A5D9ADEA0E55E2B08" || true

# Remove the dummy project's Git repository
rm -rf .git

# Remove any changes the build scripts did
git reset -q -- .
git checkout -- .
git clean -fd -- .
