#!/bin/bash
set -eu

cd dummy-project
SRC="../../src"
TEST=".."

$TEST/cleanup.sh

# Prepare test data
git init
git add .
git commit -m "Initial commit"
gpg --import $TEST/dummy-keys.gpg

# Parameters required by the build scripts
export PROJECT_NAME="Dummy Project"
export GO_PIPELINE_COUNTER=42
export GPG_KEYNAME=dummy@example.com

# Run tests
# TODO: extract tests to different file
# TODO: asserts for what the build does
if $SRC/build/build-release.sh
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
