#!/bin/bash
set -eu
. $(dirname $0)/utils.sh
set -v

cd staging.git
STAGING_MASTER=`git log -1 --pretty=oneline master`
STAGING_TAGS=`git tag`
cd ..
cd "$GIT_REPOSITORY"

# Pushes master branch from staging
test "$STAGING_MASTER" = "`git log -1 --pretty=oneline master`"

# Pushes tags from staging
test "$STAGING_TAGS" = "`git tag`"
