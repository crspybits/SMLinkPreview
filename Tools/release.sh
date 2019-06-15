#!/bin/bash

# Usage: release.sh <ReleaseTag>
# 	<ReleaseTag> is the tag to apply to git.
# Run this from the root of the repo. i.e., ./Tools/release.sh
# Example: 
#	./Tools/release.sh 6.0.0

# This script adapted from https://medium.com/travis-on-docker/how-to-version-your-docker-images-1d5c577ebf54

RELEASE_TAG=$1

if [ "empty${RELEASE_TAG}" == "empty" ]; then
        echo "**** Please give a release tag."
        exit
fi

# ensure we're up to date
git pull

echo "version: $RELEASE_TAG"

git add -A
git commit -m "version $RELEASE_TAG"
git tag -a "$RELEASE_TAG" -m "version $RELEASE_TAG"
git push
git push --tags
