#!/bin/bash

rm temp/*
rm temp/dump/*
cd temp/
rm log.txt
criu pre-dump -t "$1" -D dump/
sleep 22

#criu dump -v4 -R  -t "$1" --track-mem -D . --prev-images-dir dump/  --display-stats -j 2> log.txt

criu dump -R -v4 -t "$1" --track-mem -D . --prev-images-dir dump/ --ext-unix-sk --external unix[320165] --display-stats -j 2> log.txt --shell-job
