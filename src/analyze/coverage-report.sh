#!/bin/sh
set -eu
SCRIPTS=`dirname "$0"`
set -x

mvn clean verify \
    --batch-mode \
    --errors \
    -Pcoverage-report \
    -DskipTests \
    -Dinvoker.skip

ruby $SCRIPTS/generate-coverage-report-index.rb coverage-reports/index.html
