#!/bin/bash
set -e

if [ -z "$1" ] ; then
    echo "image directory not given"
    exit 1
fi

N=casperlabs/$1
C=${DRONE_COMMIT_SHA:-$(git rev-parse --short HEAD)}
git fetch -t
V=$(git describe --tags --always)

set -x
docker build -t $N:$C ./docker/$1
docker tag $N:$C $N:$V
docker tag $N:$C $N:latest
set +x
