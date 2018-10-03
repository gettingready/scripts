#!/bin/bash
#Engine and License Connector Backup

#get the current date
BACKUPTIME=`date +%Y%m%d%H%M`

#the folder that contains the files that we want to backup
SOURCE_CONF=/opt/autopilot/conf

#create a backup file using the current date in it's name
BACKUP_DIR=/tmp/backup/engine
BACKUP_CONF=$BACKUP_DIR/conf

#Check the user is root or not
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

#create the backup
tar cPzf $BACKUP_CONF-$BACKUPTIME.tar.gz $SOURCE_CONF
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Create the permissions backup
getfacl -p -R $SOURCE_CONF > $BACKUP_DIR/conf-$BACKUPTIME.permissions.txt
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 2; fi

echo "****************************************************************************"
echo "**Engine_And_License_Connector_Backup_Done_Store_At:$BACKUP_DIR**"
echo "****************************************************************************"

