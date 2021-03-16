#!/usr/bin/env bash
set -e

# TODO: make this more helpful
# Verify all variables are present
if [[ -z $PLUGIN_GPG_KEY || -z $PLUGIN_GPG_PASS || -z $PLUGIN_REGION \
        || -z $PLUGIN_REPO_NAME || -z $PLUGIN_ACL || -z $PLUGIN_PREFIX \
        || -z $AWS_SECRET_ACCESS_KEY || -z $AWS_ACCESS_KEY_ID \
        || -z $PLUGIN_DISTRIBUTION_ID || -z $PLUGIN_DEB_PATH ]]; then
    echo "ERROR: Environment Variable Missing!"
    exit 1
fi

## S3 SECTION
# Verify if first time publishing
EXISTS=$(aws s3api list-objects --bucket "$PLUGIN_REPO_NAME" | grep "$PLUGIN_PREFIX" | grep dist) || EXISTS_RET="false"
if [ "$EXISTS_RET" = "false" ]; then
    echo "First time uploading repo!"
    PUBLISH="repo"
else
    echo "Repo Exists! Defaulting to publish update..."
    PUBLISH="update"
fi

## GPG SECTION
# Copy in GPG key for signing repo
echo "$PLUGIN_GPG_KEY" >> /root/gpgkey_sec.gpg
# Import GPG KEY
gpg -q --batch --passphrase "$PLUGIN_GPG_PASS" --allow-secret-key-import --import /root/gpgkey_sec.gpg
# Remove Key File
rm /root/gpgkey_sec.gpg

## APTLY SECTION
# Move old config file to use in jq query
mv /root/.aptly.conf /root/.aptly.conf.orig
# Inject ENV Variables and save as .aptly.conf
jq --arg region "$PLUGIN_REGION" --arg bucket "$PLUGIN_REPO_NAME" --arg acl "$PLUGIN_ACL" --arg prefix "$PLUGIN_PREFIX"   '.S3PublishEndpoints[$bucket] = {"region":$region, "bucket":$bucket, "acl": $acl, "prefix": $prefix}' /root/.aptly.conf.orig > /root/.aptly.conf
if [ "$PUBLISH" = "update" ]; then
    aptly mirror create -ignore-signatures local-repo https://${PLUGIN_REPO_NAME}/${PLUGIN_PREFIX}/ bionic main
    aptly mirror update -ignore-signatures local-repo
    # Found an article that same using 'Name' will select all packages for us
    aptly repo import local-repo release Name
fi
# Add .debs to the local repo
aptly repo add release "$PLUGIN_DEB_PATH"/*.deb
# Publish to S3
aptly publish repo -batch -passphrase="$PLUGIN_GPG_PASS" release s3:${PLUGIN_REPO_NAME}:

## CLOUDFRONT SECTION
# Invalidate the cloudfront cache
echo "Invalidating Cloudfront..."
aws cloudfront create-invalidation --distribution-id "$PLUGIN_DISTRIBUTION_ID" --paths "/$PLUGIN_PREFIX/*" > /dev/null 2>&1
