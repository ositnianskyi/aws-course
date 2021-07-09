#!/bin/bash
bucketName=os-aws-cource-bucket-test
calc=jars/calc-0.0.2-SNAPSHOT.jar
persist=jars/persist3-0.0.1-SNAPSHOT.jar

aws s3 cp $calc s3://$bucketName/$calc --acl private
aws s3 cp $persist s3://$bucketName/$persist --acl private