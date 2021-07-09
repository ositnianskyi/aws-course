#!/bin/bash
bucketName=os-aws-cource-bucket-test
uri=s3://os-aws-cource-bucket-test/jars
jar=calc-0.0.2-SNAPSHOT.jar

sudo su
yum -y update
yum install -y java-1.8.0-openjdk
aws s3 cp $uri/$jar .
java -jar $jar