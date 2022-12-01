#!/bin/bash
#create the vm and activate pml
./start.sh
xl create conf_hadoop.cfg
#xl create conf.cfg
#xl enable-log-dirty 1

#pin the cpus
xl vcpu-pin 0 0 0
xl vcpu-pin 0 1 1
xl vcpu-pin 0 2 0
xl vcpu-pin 0 3 1

#code for start.sh
#/etc/init.d/xencommons start
# brctl addbr xenbr0
# ifconfig xenbr0 10.0.0.1
