#!/bin/bash
sudo aws s3 cp ${uri} /init_files --recursive
sudo chmod -R 755 /init_files
sudo yum -y update
sudo yum install -y postgresql