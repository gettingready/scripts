#!/bin/bash
#
# Description : The backup script will complete the backup in 3 phases -
#  1. First Phase: Taking backup of Keyspace SCHEMA
#  2. Second Phase: Taking snapshot of keyspaces
#  3. Third Phase: Taking configuration backup with permissions

## In below given variables - require information to be feed by system admin##
# For _NODETOOL , you can replace $(which nodetool) with  absolute path of nodetool command.
#if there is no nodetool   in /usr/bin/which do export the path by below export command

export PATH="$PATH:/opt/autopilot/cassandra/bin/"

_MAIN_CONF=/opt/autopilot/cassandra/conf
_BACKUP_DIR=/tmp/backup/cassandra/
#_BACKUP_CONF=$_BACKUP_DIR/
_DATA_DIR=/var/lib/cassandra/data
_NODETOOL=$(which nodetool)

## Do not edit below given variable ##
_BACKUP_TIME=`date +%Y%m%d%H%M`

 
##Check if user is root ##

if [ "$USER" != "root" ]; then
    echo "You are not the root user"
    echo "To use backup please use: sudo backup"
    exit
fi

###### Create / check backup Directory ####

if [ -d  "$_BACKUP_DIR" ]
then
echo "$_BACKUP_DIR already exist"
else
mkdir -p "$_BACKUP_DIR"
fi

#if [ -d  "$_BACKUP_CONF" ]
#then
#echo "$_BACKUP_CONF already exist"
#else
#mkdir -p "$_BACKUP_CONF"
#fi

#####Exporting Schema and Delete old Snapshots###
echo "Exporting the schemas"
/opt/autopilot/setup/cassandra/scripts/export_casssandra_schema.sh
echo "Files will be in /opt/autopilot/conf/schemas"

#rm -rf  $_DATA_DIR/*/*/backups/* ##incremental backups

echo "Clearing old snapshots"
$_NODETOOL -h localhost -p 7199 clearsnapshot 
##-t $(echo "backup"`date +"%Y%m%d-%H%M"`)
#find $_DATA_DIR/*/*/snapshots/*  -type d -mmin -40 -execdir rm -rf '{}' \;

#####SECTION 2: Creating Snapshots###########################
echo "Creating a new Snapshot"
$_NODETOOL -h localhost -p 7199 snapshot -t $(echo "backup"`date +"%Y%m%d-%H%M"`)
$_NODETOOL -h localhost flush

#####SECTION 3: Configuration Backup with Permissions#######
rsync -raptgoDXA $_MAIN_CONF $_BACKUP_DIR
rsync -raptgoDXA $_DATA_DIR $_BACKUP_DIR
