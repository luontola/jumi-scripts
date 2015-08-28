#!/bin/sh
set -eu
: ${PROJECT_NAME:?}
SCRIPTS=`dirname "$0"`
set -x

VERSION=`cat build/version`
NEXUS_PLUGIN="org.sonatype.plugins:nexus-staging-maven-plugin:1.4.4"
PROFILE_ID="2801a17694e2ea"

# Upload and close the OSSRH staging repository
mvn $NEXUS_PLUGIN:deploy-staged-repository \
    -DnexusUrl=https://oss.sonatype.org/ \
    -DserverId=ossrh-releases-fi.jumi \
    -DstagingProfileId="$PROFILE_ID" \
    -DrepositoryDirectory=staging \
    -DstagingDescription="$PROJECT_NAME $VERSION"

# TODO: do a smoke test on the closed staging repository before releasing

# The stagingRepositoryId is a required parameter, but "rc-release" won't read
# it from the properties file (and "release" doesn't work without a project),
# so we must read it from the properties file ourselves.
REPOSITORY_ID=`sed -n -r 's/stagingRepository\.id=(\w+)/\1/p' "staging/$PROFILE_ID.properties"`

# Release the OSSRH staging repository
mvn $NEXUS_PLUGIN:rc-release \
    -DnexusUrl=https://oss.sonatype.org/ \
    -DserverId=ossrh-releases-fi.jumi \
    -DstagingRepositoryId="$REPOSITORY_ID" \
    -DstagingDescription="$PROJECT_NAME $VERSION"
