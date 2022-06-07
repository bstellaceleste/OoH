#!/bin/bash

cd temp/

criu dump -R -v4 -t "$1" --pml --track-mem -D . --prev-images-dir dump/ --ext-unix-sk --external unix[320165] --display-stats -j 2> log.txt --shell-job
