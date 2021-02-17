FROM alpine:3.12

RUN apk add --no-cache bash python3 py-pip py-setuptools ca-certificates libmagic curl jq git
RUN pip3 install python-dateutil python-magic toml

RUN S3CMD_CURRENT_VERSION=`curl -fs https://api.github.com/repos/s3tools/s3cmd/releases/latest | grep tag_name | sed -E 's/.*"v?([0-9\.]+).*/\1/g'` \
    && mkdir -p /opt \
    && wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_CURRENT_VERSION}/s3cmd-${S3CMD_CURRENT_VERSION}.zip \
    && unzip s3cmd-${S3CMD_CURRENT_VERSION}.zip -d /opt/ \
    && rm -f s3cmd-${S3CMD_CURRENT_VERSION}.zip \
    && cd /opt/s3cmd-${S3CMD_CURRENT_VERSION} \
    && python3 setup.py install \
    && cd / \
    && ls /usr/bin/s3cmd

ENV ENV="/etc/profile"
ENV LC_ALL en_US.UTF-8
