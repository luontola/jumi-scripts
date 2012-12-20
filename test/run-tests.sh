#!/bin/bash
set -eu

export TEST=$(readlink -f $(dirname $0))
export SRC=$(readlink -f "$TEST/../src")

cd dummy-project
$TEST/cleanup.sh

# Prepare test data
git init
git add .
git commit -m "Initial commit"
gpg --import $TEST/dummy-keys.gpg

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
