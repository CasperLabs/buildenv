#!/bin/bash

# #Ask user for tag
# echo "Please enter the git tag you wish to upload..."
# read GIT_TAG

GIT_TAG="$1"

BINTRAY_HOME=/opt/bintray
ARTIFACTS_DIR="$2"

#VARS
SEM_VER_REG="^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(\-(0|[1-9][0-9]*|[0-9]*[A-Za-z-][0-9A-Za-z-]*)(\.(0|[1-9][0-9]*|[0-9]*[A-Za-z-][0-9A-Za-z-]*))*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$"

SEM_VER_NO_V="${GIT_TAG:1}" 
DEB_META_VERSION=${SEM_VER_NO_V}
RPM_META_VERSION="${GIT_TAG:1:1}-${GIT_TAG:3}"

DEB_META_PATH="${BINTRAY_HOME%/}/artifacts/casperlabs_${DEB_META_VERSION}_all.deb"
RPM_META_PATH="${BINTRAY_HOME%/}/artifacts/rpmbuild/RPMS/x86_64/casperlabs-${RPM_META_VERSION}.x86_64.rpm"

CL_RPM_ARRAY=(casperlabs-client-${SEM_VER_NO_V}-1.noarch.rpm
              casperlabs-engine-grpc-server-${SEM_VER_NO_V}-1.x86_64.rpm
              casperlabs-node-${SEM_VER_NO_V}-1.noarch.rpm)

CL_DEB_ARRAY=(casperlabs-client_${SEM_VER_NO_V}_all.deb
              casperlabs-engine-grpc-server_${SEM_VER_NO_V}_amd64.deb
              casperlabs-node_${SEM_VER_NO_V}_all.deb)

if ! [[ $GIT_TAG =~ $SEM_VER_REG ]]; then
    echo "Please enter a proper semver tag. ie. v0.8.0"
    exit 1
fi

#Ensure upload directory is available
mkdir -p ${PWD}/upload

# Copy metapackages to upload dir
if [ -f "$DEB_META_PATH" ] && [ -f "$RPM_META_PATH" ]; then
    cp ${DEB_META_PATH} "$ARTIFACTS_DIR"
    cp ${RPM_META_PATH} "$ARTIFACTS_DIR"
else
    echo "Metapackages not found for git tag: $GIT_TAG"
    exit 1
fi


#Switch dir
echo "Switching to upload directory: $ARTIFACTS_DIR"
cd "$ARTIFACTS_DIR"

#Download from github
echo ""
echo "Downloading packages from github:${GIT_TAG} ..."
for i in ${CL_RPM_ARRAY[@]}; do
    curl -LJO https://github.com/CasperLabs/CasperLabs/releases/download/${GIT_TAG}/${i} 
done
for i in ${CL_DEB_ARRAY[@]}; do
    curl -LJO https://github.com/CasperLabs/CasperLabs/releases/download/${GIT_TAG}/${i}
done

