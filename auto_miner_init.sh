#! /bin/sh
### BEGIN INIT INFO
# Provides:          auto_miner_init
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: auto_miner_init.
# Description:       auto_miner_init.
### END INIT INFO

account_conf="./account.conf"
local_conf="./miner_info.json"
LOG_FILE="./auto_miner_init.log"
LOG_ERROR="./error.log"
User=""
Worker="" 
Phone=""
Name=""

cd /home/pi/MXMiner/Auto-miner

#exec 2>>${LOG_ERROR}  # send stderr from rc.local to a log file    
#set -x                # tell sh to display commands before execution


if [ -f $account_conf ]; then
    Phone=`jq -r '.Phone' $account_conf`
    Name=`jq -r '.Name' $account_conf`
    echo $(date +%F%n%T) "Phone: $Phone" >>${LOG_FILE}
    echo $(date +%F%n%T) "Name: $Name" >>${LOG_FILE}
fi

if [ -f $local_conf ]; then
    User=`jq -r '.Config.User' $local_conf`
    Worker=`jq -r '.Config.Worker' $local_conf`
    echo $(date +%F%n%T) "User: $User" >>${LOG_FILE}
    echo $(date +%F%n%T) "Worker: $Worker" >>${LOG_FILE}
fi

if [ $Phone ]; then
	if [ $User != $Phone ]; then
		echo $(date +%F%n%T) "update Config.User to $Phone" >>${LOG_FILE}
		`jq -r ".Config.User = \"$Phone\"" $local_conf > "./tmp.json" && mv "./tmp.json" $local_conf`
	fi
fi

if [ $Name ]; then
	if [ $Worker != $Name ]; then
		echo $(date +%F%n%T) "update Config.Worker to $Name" >>${LOG_FILE}
	`	jq -r ".Config.Worker = \"$Name\"" $local_conf > "./tmp.json" && mv "./tmp.json" $local_conf`
	fi
fi

sleep 60

echo $(date +%F%n%T) "Start auto_miner !!!!" >>${LOG_FILE}
./auto_miner >/dev/null 2>/dev/null &

