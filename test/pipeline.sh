#!/bin/bash
set -eu

# Parameters required by the build scripts
export PROJECT_NAME="Dummy Project"
export GO_PIPELINE_COUNTER=42
export GPG_KEYNAME=dummy@example.com

$SRC/build/build-release.sh

# TODO: asserts for what the build does
