#!/usr/bin/env bash
#This Script will install apche 2 and compress log and copy it on s3
apt update -y
dpkg --get-selections | grep apache > /dev/null 2>&1
if [ $? != 0 ]
then
        apt install apache2 -y
fi
service apache2 status | grep "active (running)" > /dev/null 2>&1
if [ $? != 0 ]
then
        service apache2 restart > /dev/null
fi
timestamp=$(date '+%d%m%Y-%H%M%S')
myname=anjali
s3_bucket=upgrad-anjali
tar -cvf  /tmp/${myname}-httpd-logs-${timestamp}.tar  /var/log/apache2/*.log
apt install awscli -y
aws s3 \
        cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
        s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

