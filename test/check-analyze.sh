#!/bin/bash
set -eu
. $(dirname $0)/utils.sh
set -v

# Produces coverage reports
test -f dummy-core/target/pit-reports/index.html

# Generates an index page to the coverage reports
test -f coverage-reports/index.html
cat coverage-reports/index.html | contains-line '    <li><a href="dummy-core/target/pit-reports/index.html">dummy-core</a></li>'
