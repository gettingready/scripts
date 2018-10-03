#! /bin/bash
MAIN_DATA=/var/lib/autopilot/graphit/data
SOURCE_CONF=/opt/autopilot
BLOBSTORE=/opt/autopilot/graphit/tools/graphit-blobstore-upload
BLOBINCRD_BLOB=/var/lib/autopilot/hdfs/backup
TMP_CONF=/tmp/backup/graphdb/conf
TMP_KAFKA=/tmp/backup/graphdb/kafka
TMP_ELASTIC=/tmp/backup/graphdb/elasticsearch
TMP_BLOB=/tmp/backup/graphdb/blobstore

echo "---------------------LET THE RESTORATION BEGIN-----------------------------"
#Check the user is root or not
if [ "$USER" != "root" ]; then
    echo "You are not the root user"
    echo "To use backup please use: sudo backup"
    exit
fi

echo "*stopping the GRAPHIT service*"
/opt/autopilot/admin/stop-autopilot.sh -a


echo "--------------------------------------------------"
echo "### copying conf files from $TMP_CONF"
rsync -raptgoDXA  $TMP_CONF $SOURCE_CONF


echo "--------------------------------------------------"
echo "### copying Kafka files from $TMP_KAFKA"
rsync -raptgoDXA  $TMP_KAFKA $MAIN_DATA

#echo "--------------------------------------------------"
#echo "### Copying BlobData files from $TMP_BLOB"
#rsync -raptgoDXA  $TMP_BLOB $BLOBINCRD_BLOB
#$BLOBSTORE

echo "--------------------------------------------------"
echo " ### Copying ElasticSearchdata files from  $TMP_ELASTIC "
rsync -raptgoDXA  $TMP_ELASTIC $MAIN_DATA

#Starting graphit service
echo "**Starting graphit services**"
/opt/autopilot/admin/start-autopilot.sh -a

#
if ps ax | grep -v grep | grep hadoop > /dev/null
then
    echo "hadoop service running, everything is fine"
else
    echo "hadoop is not running, configuring the service"
    echo "localhost"| /opt/autopilot/setup/autopilot-config --component hadoop
fi

#echo "Restore index data"
#/opt/autopilot/graphit/tools/graphit-faunus --job /opt/autopilot/conf/graphit-faunus/jobs/index-all.properties


echo "--------------------------------------------------"
echo " Restoration completed and Graphit service started"
echo "--------------------------------------------------"
