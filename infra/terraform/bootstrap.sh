#!/usr/bin/env bash


echo "bootstrap scripts go here!!!" >&2

yum update -y

yum -y install httpd

echo "<html><h2>Hi there! whatcha doin' today?</h2></html>" > /var/www/html/index.html

service httpd start
chkconfig httpd on
