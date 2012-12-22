#!/bin/bash
set -eu
set -v

# In build metadata:
cd build

    # Saves version number
    cat version | grep --line-regexp --quiet --fixed-strings "0.1.42"

    # Saves Git revision
    cat revision | grep --line-regexp --quiet "[a-f0-9]\{40\}"

    # Saves release notes
    cat release-notes | grep --line-regexp --quiet "\- Did more stuff"

    # Creates build summary page
    test -f build-summary.html

cd ..

# In staging Maven repository:
cd staging

    # Deploys artifacts to local staging repository
    test -f com/example/dummy-core/0.1.42/dummy-core-0.1.42.jar
    test -f com/example/parent/0.1.42/parent-0.1.42.pom

    # Doesn't deploy the aggregate POM (requires maven-deploy-plugin configuration)
    test ! -e com/example/dummy-project

    # Signs artifacts
    gpg --verify com/example/dummy-core/0.1.42/dummy-core-0.1.42.jar.asc

cd ..

# In staging Git repository:
cd staging.git

    # Tags the release
    git tag | grep --line-regexp --quiet --fixed-strings "v0.1.42"

    # The tag is signed
    git tag -v v0.1.42

    # Tag message contains release name and release notes
    git for-each-ref --format="%(subject)" refs/tags/v0.1.42 | grep --line-regexp --quiet --fixed-strings "Jumi 0.1.42"
    git for-each-ref --format="%(body)" refs/tags/v0.1.42 | grep --line-regexp --quiet "\- Did more stuff"

    # Commits release notes with the release version and date
    git log -1 --pretty=%s v0.1.42 | grep --line-regexp --quiet --fixed-strings "Release 0.1.42"
    git show v0.1.42:RELEASE-NOTES.md | grep --line-regexp --quiet --fixed-strings "### Jumi 0.1.42 (`date --iso-8601`)"

    # Prepares release notes for the next development increment
    git log -1 --pretty=%s master | grep --line-regexp --quiet --fixed-strings "Prepare for next development iteration"
    git show master:RELEASE-NOTES.md | grep --line-regexp --quiet --fixed-strings "### Upcoming Changes"

cd ..
