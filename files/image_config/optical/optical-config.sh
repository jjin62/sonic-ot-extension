#!/bin/bash

cp /usr/share/sonic/templates/optical_config.j2 /etc/sonic/optical_config.json
python /usr/local/lib/python3.9/dist-packages/redisdl.py -d 4 -l /etc/sonic/optical_config.json

PLATFORM=${PLATFORM:-`sonic-cfggen -H -v DEVICE_METADATA.localhost.platform`}
sonic-cfggen -j /usr/share/sonic/device/$PLATFORM/ot-metadata.json --write-to-db