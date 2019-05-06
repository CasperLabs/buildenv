#!/bin/bash
builtin echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

set -x
docker push $N:$V
docker push $N:latest

#docker push $N:$V-java8
#docker push $N:latest-java8
set +x
