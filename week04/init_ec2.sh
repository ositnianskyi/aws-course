#!/bin/bash
sudo su
yum -y update
yum install -y httpd
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>This is WebServer from ${env} subnet</h1></html>" > index.html