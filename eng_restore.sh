#!/bin/bash
#Engine and License Connector restore

#the folder that contains the files that we want to backup
RESTORE_CONF=/opt/autopilot/conf

#the folder that contains the files that we want to restore
BACKUP_DIR=/tmp/backup/engine
BACKUP_CONF=`ls -t1 $BACKUP_DIR/conf*tar.gz | head -n 1`
BACKUP_PER_CONF=`ls -t1 $BACKUP_DIR/conf*permissions.txt | head -n 1`

#Checking component status
SERVICE_ENGINE=`ps -eaf | grep -i engine |sed '/^$/d'| wc -l `

#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi

#Stop if the services are running
if [[ $SERVICE_ENGINE> 1 ]]; then
   echo "*******************************"
   echo "*stoping the ENGINE service*"
   echo "*******************************"
   /opt/autopilot/admin/stop-autopilot.sh engine
else
   echo "***************************"
   echo "*ENGINE service not runnig*"
   echo "***************************"
fi

#create a restore file using the current date in it's name
tar xfpz $BACKUP_CONF -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Restore the permissions
setfacl  -R --restore=$BACKUP_PER_CONF
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Starting all services
echo "*************************"
echo "**Starting all services**"
echo "*************************"
/opt/autopilot/admin/start-autopilot.sh engine

echo "*****************************************************************************************"
echo "**********ENGINE_AND_LICENSE_CONNECTOR_RESTORATION_DONE*******************"
echo "*****************************************************************************************"


