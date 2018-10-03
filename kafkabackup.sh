#! /bin/bash

###This script shows how to directly sync kafka data to s3###
###This should be used if you want to take incremental backup particular to this component###

ORIG_FILE=/var/lib/autopilot/graphit/data/kafka
#s3 bucket name that contains backup
S3_BUCKET=kafkaincr

#Check the user user privileges and backup dir exits or not.
if [ "$USER" != "root" ]; then
    echo "********************************************************************"
    echo "****   You are not the root user,To use backup please use: sudo ****"
    echo "********************************************************************"
    exit
fi

if [ ! -d $BACKUP_DIR ]; then
    mkdir -p $BACKUP_DIR
fi

cd $BACKUP_DIR


echo "incremental backup is processing"


##These below commented lines can be used if you want to take backup to your current machine##
#BACKUP_DIR=/tmp/backup/kafka/
#BACKUPTIME=`date +%Y%m%d%H%M`
#rsync -raptgoDXA  $ORIG_FILE $BACKUP_DIR$BACKUPTIME
#        echo "File being compressed"
#tar -czf $BACKUP_DIR$BACKUPTIME.tar.gz $BACKUP_DIR$BACKUPTIME


##If you are copying to Local machines below lines should be commented##

echo "syncing file to S3"
aws s3 sync $ORIG_FILE  s3://$S3_BUCKET/




