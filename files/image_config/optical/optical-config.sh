#!/bin/bash

PLATFORM=${PLATFORM:-`sonic-cfggen -d -v DEVICE_METADATA.localhost.platform`}
sonic-cfggen -j /usr/share/sonic/device/$PLATFORM/ot-metadata.json --write-to-db
HWSKU=${HWSKU:-`sonic-cfggen -d -v DEVICE_METADATA.localhost.hwsku`}
sonic-cfggen -j /usr/share/sonic/device/$PLATFORM/$HWSKU/optical_config.json --write-to-db
sonic-cfggen -j /usr/share/sonic/device/$PLATFORM/$HWSKU/platform_config.json --write-to-db
