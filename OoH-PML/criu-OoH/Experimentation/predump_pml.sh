#!/bin/bash

rm temp/*
rm temp/dump/*
cd temp/

criu pre-dump -t "$1" --pml -D dump/
