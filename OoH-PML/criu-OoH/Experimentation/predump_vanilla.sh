#!/bin/bash

rm temp/*
rm temp/dump/*
cd temp/
rm log.txt
criu pre-dump -t "$1" -D dump/
