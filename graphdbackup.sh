#! /bin/bash

##FILES WHICH WILL BE COPIED##
ELASTIC_DIR=/var/lib/autopilot/graphit/data/elasticsearch
KAFKA_FILE=/var/lib/autopilot/graphit/data/kafka
SOURCE_CONF=/opt/autopilot/conf
BLOBSTORE=/opt/autopilot/graphit/tools/graphit-blobstore-download
BLOBINCRD=/var/lib/autopilot/hdfs/backup/blobstore
TMP_CONF=/tmp/backup/graphdb


#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "You are not the root user"
    echo "To use backup please use: sudo backup"
    exit
fi

#Check the backup dir exists, if not create dir
if [ ! -d $TMP_CONF ]; then
    mkdir -p  $TMP_CONF
fi

#cd $TMP_BACKUP
rsync -raptgoDXA  $SOURCE_CONF $TMP_CONF

echo "incremental backup is processing"

echo " Syncing kafka data to backup"
rsync -raptgoDXA  $KAFKA_FILE  $TMP_CONF


#Backing up of blobstore data
$BLOBSTORE

echo " Syncing blobstore data to backup"
rsync -raptgoDXA  $BLOBINCRD  $TMP_CONF

#Backing up of elasticsearch data
echo " Syncing elasticsearch data to backup"
rsync -raptgoDXA $ELASTIC_DIR $TMP_CONF
