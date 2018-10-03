#!/bin/bash
#Hadoop backup

#get the current date
BACKUPTIME=`date +%Y%m%d%H%M`

#the folder that contains the files that we want to backup
SOURCE_CONF=/opt/autopilot/hadoop/conf

#create a backup file using the current date in it's name
BACKUP_DIR=/tmp/backup/hadoop
BACKUP_CONF=$BACKUP_DIR/conf
BACKUP_HADOOP_PER=$BACKUP_DIR/hadoop

#Check the user user privileges and backup dir exits or not.
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi

#Check the backup dir exists, if not create dir
if [[ -e $BACKUP_DIR ]]; then
   echo "  "
    else
            mkdir -p $BACKUP_DIR
   echo "  "
fi

echo "*******************************"
echo "**CREATING_THE_HADOOP_BACK_UP**"
echo "*******************************"
#create the backup
tar cpzf $BACKUP_CONF-$BACKUPTIME.tar.gz -P $SOURCE_CONF
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Create the permissions backup
getfacl -p -R $SOURCE_CONF > $BACKUP_DIR/hadoop-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

echo "***************************************************************************************"
echo "******HADOOP_BACKUP_AND_PERMISSION_BACKUP_DONE_STORE_AT:$BACKUP_DIR****"
echo "***************************************************************************************"
