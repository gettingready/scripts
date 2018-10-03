#!/bin/bash
#connector_Restore

#the folder that contains the files that we want to restore
BACKUP_DIR=/tmp/backup/connectit
BACKUP_CONF=`ls -t1  $BACKUP_DIR/conf*tar.gz | head -n 1`
BACKUP_YAML=`ls -t1  $BACKUP_DIR/yaml*tar.gz | head -n 1`
BACKUP_CONNECT=`ls -t1 $BACKUP_DIR/connect*tar.gz | head -n 1`
BACKUP_PROP=`ls -t1 $BACKUP_DIR/properties*tar.gz | head -n 1`

BACKUP_PER_CONF=`ls -t1  $BACKUP_DIR/conf*txt | head -n 1`
BACKUP_PER_YAML=`ls -t1  $BACKUP_DIR/yaml*txt | head -n 1`
BACKUP_PER_CONNECT=`ls -t1  $BACKUP_DIR/connect*txt | head -n 1`
BACKUP_PER_PROP=`ls -t1  $BACKUP_DIR/prop*txt | head -n 1`

#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi

#Stopping all service and 
echo "*******************************"
echo "*stopping all service*"
echo "*******************************"
/opt/autopilot/admin/stop-autopilot.sh -a
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#create a restore file using the current date in it's name
echo "***********************"
echo "**Restoring the files**"
echo "***********************"
tar xfz $BACKUP_CONF -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 2; fi
tar xfz $BACKUP_YAML -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 3; fi
tar xfz $BACKUP_CONNECT -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 4; fi
tar xfz $BACKUP_PROP  -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 5; fi

#Restore the permissions
setfacl -R --restore=$BACKUP_PER_CONF
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 6; fi
setfacl -R --restore=$BACKUP_PER_YAML
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 7; fi
setfacl -R --restore=$BACKUP_PER_CONNECT
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 8; fi
setfacl -R --restore=$BACKUP_PER_PROP
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 9; fi

echo "************************"
echo "**PERMISSIONS Restored**"
echo "************************"

#Starting all service
echo "*************************"
echo "**Starting all services**"
echo "*************************"
/opt/autopilot/admin/start-autopilot.sh -a
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 10; fi

echo "***************** *********************"
echo "********CONNECTOR_RESTORE_DONE*********"
echo "***************************************"
