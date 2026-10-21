#!/bin/sh

DIR=$(pwd)
VERSION=$1
TYPE=$2
ENV=$3
# "local" builds the arm64 image into this Mac's Docker instead of publishing
TARGET=${4:-publish}

SUFFIX=''

build_image () {
    env=$1
    version=$2
    suffix=$3

    # Never pushed, so the published Linux tags are not touched. Plain
    # `docker build` resolves FROM against local images, so the dev image is
    # built on the arm64 prod image made just before it.
    if [ "$TARGET" = 'local' ]
    then
        echo "Building the $env image for this Mac (linux/arm64, not pushed)"
        docker build --platform linux/arm64 -t brian978/php-"$TYPE:$version$suffix" "$DIR/$version/$TYPE/$env" || exit 1
        return
    fi

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
        build_image 'prod' "$VERSION" ''
    fi
fi

# Build and PUSH the image
build_image "$ENV" "$VERSION" "$SUFFIX"
