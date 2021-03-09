#!/bin/bash
/etc/init.d/mysql start
/etc/init.d/zabbix-server start
/etc/init.d/zabbix-agent start
/etc/init.d/apache2 start
while true; do
    tail -f /var/log/apache2/*.log
    sleep 5
done
