#!/bin/bash
uri=s3://os-aws-cource-bucket-test/jars
jar=persist3-0.0.1-SNAPSHOT.jar
rds=${rds_host}

sudo su

export RDS_HOST=$rds
echo "RDS_HOST=$rds" >> /etc/environment

echo 'SELECT * FROM LOGS;' > get_logs.sql

yum -y update
yum install -y postgresql
yum install -y java-1.8.0-openjdk

aws s3 cp $uri/$jar .
java -jar $jar
