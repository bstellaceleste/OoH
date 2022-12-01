#!/bin/bash

rm temp/*
rm temp/dump/*
cd temp/

criu pre-dump -t "$1" --pml -D dump/
sleep 20
#criu dump -R -t "$1" --pml --track-mem -D . --prev-images-dir dump/ --display-stats -j 2> log.txt

criu dump -R -v4 -t "$1" --pml --track-mem -D . --prev-images-dir dump/ --ext-unix-sk --external unix[320165] --display-stats -j 2> log.txt --shell-job
