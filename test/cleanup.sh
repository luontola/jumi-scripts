#!/bin/bash
set -eu

cd $(dirname $0)/dummy-project

# Remove the dummy keys used for signing
gpg --batch --delete-secret-keys "D9043920AF8818F44D4D2C2A5D9ADEA0E55E2B08" || true
gpg --batch --delete-keys "D9043920AF8818F44D4D2C2A5D9ADEA0E55E2B08" || true

# Remove the dummy project's Git repository
rm -rf .git

# Remove any changes the build scripts did
git reset -q -- .
git checkout -- .

# Need an extra -f to remove embedded repositories
# http://rackerhacker.com/2012/10/24/using-git-clean-to-remove-subdirectories-containing-git-repositories/
git clean -ffxd -- .
