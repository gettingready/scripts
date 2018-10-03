#!/bin/bash
#iam backup

#get the current date
BACKUPTIME=`date +%Y%m%d%H%M`

#the folder that contains the files that we want to backup
SOURCE_CONF=/opt/autopilot/wso2is/repository/conf
SOURCE_SEC=/opt/autopilot/wso2is/repository/resources/security
SOURCE_DATA=/opt/autopilot/wso2is/repository/data
#SOURCE_WSO2IS_PER=/opt/autopilot/wso2is/repository

#create a backup file using the current date in it's name
BACKUP_DIR=/tmp/backup/iam
BACKUP_CONF=$BACKUP_DIR/conf
BACKUP_SEC=$BACKUP_DIR/security
BACKUP_DATA=$BACKUP_DIR/data
BACKUP_WSO2IS_PER=$BACKUP_DIR

#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "You are not the root user"
    echo "To use backup please use: sudo backup"
    exit
fi

#Check the backup is exits or if not create dir
if [[ -e $BACKUP_DIR ]]; then
   echo "  "
    else
            mkdir -p $BACKUP_DIR
   echo "  "
fi

#create the backup
tar cpzf  $BACKUP_CONF-$BACKUPTIME.tar.gz -P $SOURCE_CONF
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 2; fi
tar cpzf  $BACKUP_SEC-$BACKUPTIME.tar.gz -P $SOURCE_SEC
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 3; fi
tar cpzf  $BACKUP_DATA-$BACKUPTIME.tar.gz -P $SOURCE_DATA
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 4; fi
/opt/autopilot/wso2is/arago_setup/create_online_backup.sh
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 5; fi

#Create the permissions backup
getfacl -p -R $SOURCE_CONF > $BACKUP_DIR/conf-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 6; fi
getfacl -p -R $SOURCE_SEC > $BACKUP_DIR/sec-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 7; fi
getfacl -p -R $SOURCE_DATA > $BACKUP_DIR/data-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 8; fi


echo "*****************************************************************************"
echo "*****IAM_BACKUP_AND_PERMISSION_BACKUP_DONE_###_STORES_AT:$BACKUP_DIR*****"
echo "*****************************************************************************"
