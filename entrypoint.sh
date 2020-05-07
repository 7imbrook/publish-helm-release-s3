#!/bin/sh -l

set +x

S3CMD="s3cmd --host-bucket='sfo2.digitaloceanspaces.com' --host sfo2.digitaloceanspaces.com"

publish() {
    $S3CMD get s3://helm-charts/index.yaml
    helm repo index --merge index.yaml .
    PACKAGE=$(ls *.tgz)
    $S3CMD put -P ./$PACKAGE s3://helm-charts/$PACKAGE
    $S3CMD put -P ./index.yaml s3://helm-charts/index.yaml
}

helm repo add personal https://helm-charts.sfo2.digitaloceanspaces.com/

# The following only works once we're publish at least once
VERSION=$(helm inspect chart personal/service | grep "version:" | cut -d " " -f 2)
CURRENT_VERSION=$(cat ./Chart.yaml | grep "version:" | cut -d " " -f 2)
if [[ "$VERSION" == "$CURRENT_VERSION" ]]
then
    VERSION=$(helm inspect chart personal/service | grep "version:" | cut -d " " -f 2)
    helm package --version $VERSION-cont .
else
    helm package .
fi

publish;

time=$(date)
echo "::set-output name=time::$time"