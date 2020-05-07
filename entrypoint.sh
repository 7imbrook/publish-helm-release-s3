#!/bin/sh -l

echo "Hello $1"
ls
pwd
helm package .

s3cmd --host sfo2.digitaloceanspaces.com ls s3://helm-charts

time=$(date)
echo "::set-output name=time::$time"