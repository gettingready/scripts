#!/bin/bash
#
# Description : The restore script will complete the backup in 4 phases -
#  1. First Phase: Stopping all components except cassandra
###NOTE: Disable any cron/batch jobs connecting cassandra (cassandra repair jobs, any Hadoop based batch jobs, license connector)
#  2. Second Phase: Restoring Schema and stopping cassandra
#  3. Third Phase: Cleaning commitlogs and restoring snapshot data
#  4. Fourth Phase: Removing old snapshots and Repair cassandra


export PATH="$PATH:/opt/autopilot/cassandra/bin/"

_MAIN_CONF=/opt/autopilot/cassandra
_BACKUP_DIR=/tmp/backup/cassandra
#_BACKUP_CONF=$_BACKUP_DIR/conf
_DATA_DIR=/var/lib/cassandra
_NODETOOL=$(which nodetool)
_COMMIT_LOG=/var/lib/cassandra/commitlog

##Check if user is root ##
if [ "$USER" != "root" ]; then
    echo "You are not the root user"
    echo "To use backup please use: sudo backup"
    exit
fi
 
#Stopping the services
echo "****************************"
echo "*stopping the all service*"
echo "****************************"
/opt/autopilot/admin/stop-autopilot.sh -a
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Starting Cassandra service
echo "--Starting--Cassandra--"
/opt/autopilot/admin/start-autopilot.sh cassandra
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi


/opt/autopilot/setup/cassandra/scripts/restore_cassandra_schema.sh

cqlsh -e "DROP keyspace autopilot";
cqlsh -e "DROP keyspace titan";
cqlsh -e "DROP keyspace graphithistory";

echo "Stopping Cassandra"
/opt/autopilot/admin/stop-autopilot.sh cassandra


rm -rf $_DATA_DIR/data/*/*
rm -rf $_COMMIT_LOG/*

rsync -raptgoDXA $_BACKUP_DIR/conf $_MAIN_CONF
rsync -raptgoDXA $_BACKUP_DIR/data $_DATA_DIR
find /var/lib/cassandra/data/ -empty -type d -delete

echo " Starting Cassandra"
/opt/autopilot/admin/start-autopilot.sh cassandra
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

$_NODETOOL repair
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

echo "Starting all other components"
/opt/autopilot/admin/start-autopilot.sh zookeeper
/opt/autopilot/admin/start-autopilot.sh hadoop
/opt/autopilot/admin/start-autopilot.sh graphit

