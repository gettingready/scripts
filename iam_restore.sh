#!/bin/bash
#IAM Restore

#Checking components status
SERVICE_WSO2IS=`ps -eaf | grep -i wso2is |sed '/^$/d'| wc -l `


#create a restore file using the current date in it's name
BACKUP_DIR=/tmp/backup/iam
BACKUP_DIR_DB=/var/lib/autopilot/wso2is/backup
BACKUP_CONF=`ls -t1 $BACKUP_DIR/conf*tar.gz | head -n 1`
BACKUP_SEC=`ls -t1 $BACKUP_DIR/security*tar.gz | head -n 1`
BACKUP_DATA=`ls -t1 $BACKUP_DIR/data*tar.gz | head -n 1`
BACKUP_DATABASE=`ls -t1 $BACKUP_DIR_DB/backup*.zip | head -n 1`
BACKUP_CONF_PER=`ls -t1 $BACKUP_DIR/conf*txt | head -n 1`
BACKUP_SEC_PER=`ls -t1 $BACKUP_DIR/sec*txt | head -n 1`
BACKUP_DATA_PER=`ls -t1 $BACKUP_DIR/data*txt | head -n 1`



#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi

#Check the service and stopping the services
echo "****************************"   
echo "*stopping the WSO2IS service*"
echo "****************************"
/opt/autopilot/admin/stop-autopilot.sh wso2is
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 1; fi

#Cleanup old data
echo "***************************"
echo "*Cleanup of old data*******"
echo "***************************"
cd /var/lib/autopilot/wso2is/database
rm -rf *.db

#create a restore file using the current date in it's name
tar xfzp $BACKUP_CONF -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 2; fi
tar xfzp $BACKUP_SEC -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 3; fi
tar xfzp $BACKUP_DATA -C /
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 4; fi
cd /tmp/restore/iam
unzip -x $BACKUP_DATABASE
chown -R arago:arago *.db

#Restore the permissions
setfacl -R --restore=$BACKUP_CONF_PER
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 5; fi
setfacl -R --restore=$BACKUP_SEC_PER
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 6; fi
setfacl -R --restore=$BACKUP_DATA_PER
if [ $? -ne 0 ]; then echo "ERROR: Previous command failed"; exit 7; fi

#Starting wso2is service
echo "*******************************"
echo "**Starting  wso2is service*****"
echo "*******************************"

/opt/autopilot/admin/start-autopilot.sh wso2is


echo "***************************************************"
echo "****************IAM_RESTORE_DONE*******************"
echo "***************************************************"

