FROM alpine

ADD https://get.helm.sh/helm-v3.2.0-linux-386.tar.gz ./helm.tar.gz
RUN tar -xvf ./helm.tar.gz
RUN mv ./linux-386/helm /usr/bin/

RUN apk add --no-cache python py-pip py-setuptools ca-certificates libmagic curl
RUN pip install python-dateutil python-magic

RUN S3CMD_CURRENT_VERSION=`curl -fs https://api.github.com/repos/s3tools/s3cmd/releases/latest | grep tag_name | sed -E 's/.*"v?([0-9\.]+).*/\1/g'` \
    && mkdir -p /opt \
    && wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_CURRENT_VERSION}/s3cmd-${S3CMD_CURRENT_VERSION}.zip \
    && unzip s3cmd-${S3CMD_CURRENT_VERSION}.zip -d /opt/ \
    && ln -s $(find /opt/ -name s3cmd) /usr/bin/s3cmd \
    && ls /usr/bin/s3cmd

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]