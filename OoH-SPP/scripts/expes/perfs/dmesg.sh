#!/bin/bash
while [ True ]; do sudo dmesg -c | grep SPP >> $1 ; done
