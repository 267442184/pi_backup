#!/bin/sh
### BEGIN INIT INFO
# Provides:          autossh
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the autossh
# Description:       starts the autossh
### END INIT INFO
if [ ! -f "/boot/dev.id" ]; then 
    echo "Pls fill /boot/dev.id with series_id of this device"
    exit 0
fi

devid=`cat /boot/dev.id`
bindport=`expr $devid + 2221`
echo "Bindport is $bindport"

case "$1" in
    start)
    echo "start autossh"
    killall -0 autossh
    if [ $? -ne 0 ];then
       sudo /usr/bin/autossh -M 888 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R $bindport:localhost:22 -i /home/pi/.ssh/id_rsa root@39.100.238.72 
    fi
    ;;
    stop)
    sudo killall autossh
    ;;
    restart)
    sudo killall autossh
    sudo /usr/bin/autossh -M 888 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R $bindport:localhost:22 -i /home/pi/.ssh/id_rsa root@39.100.238.72
    ;;
    *)
    echo "Usage: $0 (start|stop|restart)"
    ;;
esac
exit 0

