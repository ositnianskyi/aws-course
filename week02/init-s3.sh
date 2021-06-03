#!/bin/bash
region=us-west-2
bucketName=os-aws-cource-bucket-test
fileName=hello_file.txt

echo 'Hello, world.' > $fileName
aws s3 mb s3://$bucketName --region $region
aws s3api put-bucket-versioning --bucket $bucketName --versioning-configuration Status=Enabled
aws s3 cp $fileName s3://$bucketName --acl private
