#!/bin/sh
tomcatdir="/namee/systemSW/WAS/tomcat"
logdir="/namee/systemSW/thread_logs"
tomcatname="Tomcat1"
NOW=$(date +"%Y%m%d%H%M%S")

echo "==============  konggacksi  =================="
if [ $(ps -eaf | grep java | grep $tomcatdir/bin | wc -l) -eq 0 ]
then
   echo "   LAST." $tomcatname "not working"
   bash $tomcatdir/bin/startup.sh
else
   echo "================================"
   echo "   1. " $tomcatname "shutdown"
   echo " "
   bash $tomcatdir/bin/shutdown.sh
   echo "   2. WE ARE Waiting 5 SEC"
   echo " "
   sleep 5

   if [ $(ps -eaf | grep java | grep $tomcatdir/bin | wc -l) -eq 0 ]
   then
      echo "   3. Process Checking"
      echo "      - Shutdown Success"
      echo " "
   else
      echo "   3. Process Checking"
      echo "      - Shutdown Failed"
      echo " "
      ps -eaf | grep java | grep $tomcatdir/bin | awk '{print $2}' |
      while read PID
      do
        echo "   4. Thread Dump Create $PID"
        /konggacksi/systemSW/java/jdk1.6.0_39/bin/jstack $PID >> $logdir/$NOW"-"$tomcatname"-thread.log"
        echo "   5. KILL tomcat $PID"
        kill -9 $PID
        echo " "
        done
   fi

   echo "   LAST. $tomcatname RESTART"
   bash $tomcatdir/bin/startup.sh

fi
echo "==============  konggacksi =================="
exit 0
