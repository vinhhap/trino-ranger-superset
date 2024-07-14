#!/bin/bash

echo "====== Copy Trino configs ======"
/bin/cp -Lrf /tmp/trino/* /etc/trino/

if [ "$(cat /tmp/trino/is_coordinator.txt)" = "true" ]
then
    echo "====== Copy install.properties ======" 
    cp /tmp/ranger_plugin_config/install.properties /opt/ranger/ranger-trino-plugin/install.properties
    echo "====== Running script for Coordinator ======"
    /opt/ranger/ranger-trino-plugin/enable-trino-plugin.sh
fi

echo "====== Start Trino ======"
/usr/lib/trino/bin/run-trino