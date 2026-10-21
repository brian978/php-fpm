#!/bin/sh

DIR=$(pwd)
VERSION=$1
TYPE=$2
ENV=$3

SUFFIX=''

build_image () {
    env=$1
    version=$2
    suffix=$3

    # Linux servers only. arm64 is for local development on a Mac and has its
    # own build, so it no longer doubles (under emulation) the time of this one.
    platforms=linux/amd64

    # Creating a new builder for the multiplatform support
    docker buildx create --name phpbuilder --use

    # Build and PUSH the image
    echo "Building the $env image"
    docker buildx build --platform $platforms --push -t brian978/php-"$TYPE:$version$suffix" "$DIR/$version/$TYPE/$env"

    # Cleanup the builder
    docker buildx rm phpbuilder
}

# The dev image is based on the production one, so we need to compile that first if it's not present
if [ "$ENV" = 'dev' ]
then
    SUFFIX='-dev'

    echo "Production image hash: $(docker images -q brian978/php-"$TYPE":"$VERSION" 2> /dev/null)"

    # Build the prod image first as the DEV one requires it
    # shellcheck disable=SC2039
    # shellcheck disable=SC3010
    if [[ "$(docker images -q brian978/php-"$TYPE":"$VERSION" 2> /dev/null)" == "" ]]
    then
        echo "Building the production image"
        build_image 'prod' "$VERSION" "$SUFFIX"
    fi
fi

# Build and PUSH the image
build_image "$ENV" "$VERSION" "$SUFFIX"
