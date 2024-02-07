#!/bin/bash

####  check execute result
function return_val()
{
    val=`echo $?`
    if test $val -ne 0;then
        echo "#########  `pwd` is ERROR..."
        exit -1
    fi
}

#### wait app start
function wait_start()
{
    wait_time=0	
    while [ $wait_time -lt $2 ] 
    do 	
        if [ -f /var/run/$1.pid ]; then	
            break;	
        fi
        
        sleep 1	
        let wait_time++	
        echo -n "."
    done
    echo "$1 start end. wait time:$wait_time"
    if test $wait_time -gt $2;then
        echo "$1 start timeout."
    fi
}
echo "start...."

### restart rsyslogd
echo "start syslog"
service syslog restart

### start recordlogd
echo "start recordlogd ..."
/usr/local/bin/recordlogd &
wait_start recordlogd 30

### restart rsyslogd again
service syslog restart

### start syslogalm
echo "start syslogalm ..."
/usr/local/bin/syslogalm >/var/log/syslogalm.log 2>&1 &
wait_start syslogalm 8

### start operationd
echo "start operationd ..."      
/usr/local/bin/operationd >/var/log/operationd.log 2>&1 &
wait_start operation 180

### start autoctrld 
echo "start autoctrld ..."
/usr/local/bin/autoctrld >/var/log/autoctrld.log 2>&1 &

exit 0
