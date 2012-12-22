#!/bin/bash
set -eu
: ${SRC:?}
: ${GIT_REPOSITORY:?}
set -v

# Parameters required by the build scripts
export PROJECT_NAME="Dummy Project"
export GO_PIPELINE_COUNTER=42
export GPG_KEYNAME=dummy@example.com

### Build stage ###
$SRC/build/build-release.sh
$TEST/check-build.sh

### Analyze stage ###
$SRC/analyze/coverage-report.sh
$TEST/check-analyze.sh

### Publish stage ###
$SRC/publish/check-release-notes.sh
#$SRC/publish/promote-staging.sh        # TODO: cannot test without Nexus
$SRC/publish/push-staging.sh
# TODO: asserts for what publish does
