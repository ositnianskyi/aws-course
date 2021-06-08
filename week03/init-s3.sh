#!/bin/bash
bucketName=os-aws-cource-bucket-test
path=db_files

aws s3 cp $path s3://$bucketName/$path --recursive --acl private
