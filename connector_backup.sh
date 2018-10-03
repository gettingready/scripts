#!/bin/bash
#Connector backup

#get the current date
BACKUPTIME=`date +%Y%m%d%H%M`

#the folder that contains the files that we want to backup
SOURCE_CONF=/opt/autopilot/connectit/conf/*
SOURCE_YAML=/opt/autopilot/conf/arago.yaml
SOURCE_CONNECT=/etc/init.d/connect-*
SOURCE_PROP=/opt/autopilot/kafka/config/server.properties

#create a backup file using the current date in it's name
BACKUP_DIR=/tmp/backup/connectit
BACKUP_CONF=$BACKUP_DIR/conf
BACKUP_YAML=$BACKUP_DIR/yaml
BACKUP_CONNECT=$BACKUP_DIR/connect
BACKUP_PROP=$BACKUP_DIR/properties

BACKUP_PER_CONNECTIT=$BACKUP_DIR/connectit
BACKUP_PER_CONF=$BACKUP_DIR/conf
BACKUP_PER_CONNECT=$BACKUP_DIR/connect
BACKUP_PER_KAFKA=$BACKUP_DIR/kafka

#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi
#Check the backup dir is exits or if not create dir
if [[ -e $BACKUP_DIR ]]; then
   echo "  "
    else
            mkdir -p $BACKUP_DIR
   echo "  "
fi

#create the backup
tar cpzf $BACKUP_CONF-$BACKUPTIME.tar.gz -P $SOURCE_CONF
tar cpzf $BACKUP_YAML-$BACKUPTIME.tar.gz -P $SOURCE_YAML
tar cpzf $BACKUP_CONNECT-$BACKUPTIME.tar.gz -P $SOURCE_CONNECT
tar cpzf $BACKUP_PROP-$BACKUPTIME.tar.gz -P $SOURCE_PROP

#Create the permissions backup
getfacl -p -R $SOURCE_CONF > $BACKUP_DIR/conf-$BACKUPTIME.permissions.txt
getfacl -p -R $SOURCE_YAML > $BACKUP_DIR/yaml-$BACKUPTIME.permissions.txt
getfacl -p -R $SOURCE_CONNECT > $BACKUP_DIR/connect-$BACKUPTIME.permissions.txt
getfacl -p -R $SOURCE_PROP > $BACKUP_DIR/prop-$BACKUPTIME.permissions.txt
echo "***************************************************************************************"
echo "*****ZOOKEEPER_BACKUP_AND_PERMISSION_BACKUP_DONE###STORES_AT:$BACKUP_DIR*****"
echo "***************************************************************************************"
