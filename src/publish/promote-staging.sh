#!/bin/sh
set -eu
: ${PROJECT_NAME:?}
SCRIPTS=`dirname "$0"`
set -x

VERSION=`cat build/version`
NEXUS_PLUGIN="org.sonatype.plugins:nexus-staging-maven-plugin:1.4.4"

mvn $NEXUS_PLUGIN:deploy-staged-repository \
    -DnexusUrl=https://oss.sonatype.org/ \
    -DserverId=ossrh-releases \
    -DstagingProfileId=2801a17694e2ea \
    -DrepositoryDirectory=staging \
    -DstagingDescription="$PROJECT_NAME $VERSION"

# TODO: do a smoke test on the closed staging repository before releasing

mvn $NEXUS_PLUGIN:release \
    -DnexusUrl=https://oss.sonatype.org/ \
    -DserverId=ossrh-releases \
    -DaltStagingDirectory=staging \
    -DstagingDescription="$PROJECT_NAME $VERSION"
