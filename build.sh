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

    platforms=linux/amd64,linux/arm64

    # Creating a new builder for the multiplatform support
    docker buildx create --name phpbuilder --use

    # Build and PUSH the image
    echo "Building the $env image"
    docker buildx build --platform $platforms --push -t brian978/php-"$TYPE:$version$suffix" "$DIR/$version/$TYPE/$env"

    # Cleanup the builder
    docker buildx rm phpbuilder
}

if [ "$ENV" = 'dev' ]
then
    SUFFIX='-dev'

    echo "Production image hash: $(docker images -q brian978/php-"$TYPE":"$VERSION" 2> /dev/null)"

    # Build the prod image first as the DEV one requires it
    # shellcheck disable=SC2039
    if [[ "$(docker images -q brian978/php-"$TYPE":"$VERSION" 2> /dev/null)" == "" ]]
    then
        echo "Building the production image"
        build_image 'prod' "$VERSION" "$SUFFIX"
    fi
fi

# Build and PUSH the image
build_image "$ENV" "$VERSION" "$SUFFIX"
