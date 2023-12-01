#!/bin/bash

# wait until autocontol daemon started
until [[ -e /var/run/autoctrld.socket ]];
do
    sleep 1;
done
