#!/bin/bash
set -eu

export TEST=$(readlink -f $(dirname $0))
export SRC=$(readlink -f "$TEST/../src")

$TEST/cleanup.sh

# Prepare test data
gpg --import $TEST/dummy-keys.gpg

cd $TEST/dummy-project
git init
git add .
git commit -m "Initial commit"

export GIT_REPOSITORY="$TEST/dummy-project/fake-github.git"
mkdir $GIT_REPOSITORY
cd $GIT_REPOSITORY
git init --bare
cd ..
git push $GIT_REPOSITORY master

# Run tests
if $TEST/pipeline.sh
then
    $TEST/cleanup.sh
    echo ""
    echo "All tests OK"
    exit 0
else
    echo ""
    echo "Failed tests!"
    exit 1
fi
