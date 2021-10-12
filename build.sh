#!/bin/sh

DIR=$(pwd)
VERSION=$1

docker build -t brian978/php-fpm:$VERSION $DIR/$VERSION
docker push brian978/php-fpm:$VERSION