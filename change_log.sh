#! /bin/bash
LOG_DIR=/var/log/changelog/
CHANGE=changelog

#CHECKING WHETHER THE DIRECTORY EXIST#
if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR
fi

#Changing to that directory
cd $LOG_DIR

echo "Checking any files has been modified"
find /opt/autopilot/* -mtime -10  -iname *.yaml -printf "%Tc %p\n"| sort -r >> $LOG_DIR$CHANGE.log
find /opt/autopilot/* -mtime -10 -iname *.sh -printf "%Tc %p\n" | sort -nr >> $LOG_DIR$CHANGE.log
#find /opt/autopilot/* -mtime -10 -iname *.xml -printf "%Tc %p\n" | sort -nr >> $LOG_DIR$CHANGE.log
sort -k5 $LOG_DIR$CHANGE.log|uniq > $LOG_DIR/temp_log.txt
cat $LOG_DIR/temp_log.txt > $LOG_DIR$CHANGE.log
echo " File will be Generated in  $LOG_DIR$CHANGE.log"

