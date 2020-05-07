#!/bin/sh -l

echo "Hello $1"
ls
pwd
helm package .
time=$(date)
echo "::set-output name=time::$time"