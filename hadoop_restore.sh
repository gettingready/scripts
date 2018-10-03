#!/bin/bash
#Hadoop Restore

#the folder that contains the files that we want to backup
RESTORE_CONF=/opt/autopilot/hadoop/conf


#the folder that contains the files that we want to restore
BACKUP_DIR=/tmp/backup/hadoop
BACKUP_CONF=`ls -t1 $BACKUP_DIR/conf*tar.gz | head -n 1`
BACKUP_CONF_PER=`ls -t1 $BACKUP_DIR/hadoop*permissions.txt | head -n 1`

#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi

#Check the service and stopping the services
echo "*******************************"
echo "*stoping the HADOOP service*"
echo "*******************************"
/opt/autopilot/admin/stop-autopilot.sh hadoop
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#cleanup old date
echo "******************"
echo "*Cleanup old date*"
echo "******************"
#cd $SOURCE_CONF
#rm -rf *

#create a restore file using the current date in it's name
tar xpfz $BACKUP_CONF -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 2; fi

#Restore the permissions
setfacl -R --restore=$BACKUP_CONF_PER
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 3; fi

#Starting hadoop service
echo "*************************"
echo "**Starting HADOOP services**"
echo "*************************"
/opt/autopilot/admin/start-autopilot.sh hadoop
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 4; fi

echo "**************************************************************************"
echo "****************HADOOP_RESTORE_AND_RESTORE_PERMISSION_DONE*******************"
echo "**************************************************************************"

