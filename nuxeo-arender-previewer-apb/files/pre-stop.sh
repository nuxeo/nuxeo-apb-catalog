#!/bin/sh

LOGDIR=/usr/local/tomcat/logs
NOW=`date +"%Y-%m-%d_%H-%M-%S"`


mkdir -p $LOGDIR
LOGFILE=$LOGDIR/pre-stop_${POD_NAME}_${NOW}.txt

{
  echo == Netstat   =======
  netstat -an
  echo

  echo == Netstat: Number of connection by IP  =======
  netstat -an | awk  'BEGIN { FS = ":" }  /^tcp/ { arr[$8]++ } END { for( no in arr) { print  arr[no] , no } }'
  echo

  echo == Process Status info ===================
  cat /proc/1/status
  echo

  echo == Health endpoint =========================
  set +e
  wget -O - --timeout 3 localhost:8081/health/record 2>&1
  set -e
  if [ $? -gt 0 ];  then
    echo "Health endpoint resulted in ERROR"
  fi
  echo

  echo == JVM Memory usage ======================
  jcmd 1 VM.native_memory
  echo

  echo == Thread dump ===========================
  jcmd 1 Thread.print
} >> $LOGFILE 2>&1
