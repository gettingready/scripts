#!/bin/bash
#Zookeeper backup

#get the current date
BACKUPTIME=`date +%Y%m%d%H%M`

#the folder that contains the files that we want to backup
SOURCE_CONF=/opt/autopilot/zookeeper/conf
SOURCE_MYID=/var/lib/zookeeper/myid
SOURCE_LIB=/var/lib/zookeeper
SOURCE_LOG=/var/log/zookeeper

SOURCE_PER_OPT=/opt/autopilot/zookeeper
SOURCE_PER_VAR=/var/lib/zookeeper

#create a backup file using the current date in it's name
BACKUP_DIR=/tmp/backup/zookeeper
BACKUP_CONF=$BACKUP_DIR/conf
BACKUP_MYID=$BACKUP_DIR/myid
BACKUP_LIB=$BACKUP_DIR/lib
BACKUP_LOG=$BACKUP_DIR/log

BACKUP_PER_OPT=$BACKUP_DIR/opt
BACKUP_PER_VAR=$BACKUP_DIR/var

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
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 2; fi
tar cpzf $BACKUP_MYID-$BACKUPTIME.tar.gz -P $SOURCE_MYID
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 3; fi
tar cpzf $BACKUP_LIB-$BACKUPTIME.tar.gz -P $SOURCE_LIB
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 4; fi
tar cpzf $BACKUP_LOG-$BACKUPTIME.tar.gz -P $SOURCE_LOG
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 5; fi

#Create the permissions backup
getfacl -p -R $SOURCE_PER_OPT > $BACKUP_PER_OPT-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 6; fi
getfacl -p -R $SOURCE_PER_VAR > $BACKUP_PER_VAR-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 7; fi

echo "***************************************************************************************"
echo "*****ZOOKEEPER_BACKUP_AND_PERMISSION_BACKUP_DONE###STORES_AT:$BACKUP_DIR*****"
echo "***************************************************************************************"

