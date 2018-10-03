#!/bin/bash
#Zookeeper_Restore


#the folder that contains the files that we want to restore
BACKUP_DIR=/tmp/backup/zookeeper
BACKUP_CONF=`ls -t1  $BACKUP_DIR/conf*tar.gz | head -n 1`
BACKUP_MYID=`ls -t1  $BACKUP_DIR/myid*tar.gz | head -n 1`
BACKUP_LIB=`ls -t1   $BACKUP_DIR/lib*tar.gz | head -n 1`
BACKUP_LOG=`ls -t1   $BACKUP_DIR/log*tar.gz | head -n 1`
BACKUP_PER_OPT=`ls -t1  $BACKUP_DIR/opt*txt | head -n 1`
BACKUP_PER_VAR=`ls -t1  $BACKUP_DIR/var*txt | head -n 1`


#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"    
    exit
fi

#Check the service and stopping the services
echo "*stopping the ZOOKEEPER service*"
/opt/autopilot/admin/stop-autopilot.sh -a

if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Cleanup old date
echo "******************"
echo "*Cleanup old date*"
echo "******************"

rm -rf /var/lib/zookeeper/*
rm -rf /var/log/zookeeper/*
#rm -rf /opt/autopilot/zookeeper/conf/*
#rm -rf /var/lib/zookeeper/myid


#create a restore file using the current date in it's name
echo "***********************"
echo "**Restoring the files**"
echo "***********************"
tar xfz $BACKUP_CONF -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi
tar xfz $BACKUP_MYID -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi
tar xfz $BACKUP_LIB  -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi
tar xfz $BACKUP_LOG  -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Restore the permissions
setfacl -R --restore=$BACKUP_PER_OPT
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi
setfacl -R --restore=$BACKUP_PER_VAR
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

echo "************************"
echo "**PERMISSIONS Restored**"
echo "************************"

#Starting all service
echo "*************************"
echo "**Starting all services**"
echo "*************************"
/opt/autopilot/admin/start-autopilot.sh -a


echo "***********************************************************************************************"
echo "********ZOOKEEPER_AND_PERMISSION_RESTORE_DONE*Restore stores at $RESTORE_DIR*********"
echo "***********************************************************************************************"

