#!/usr/bin/env bash

DBNAME=wordpress
DBUSER=wordpressuser
DBPASSWD=qmHCmk-RNMBTa-CbYG8

sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql.service

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $DBNAME;
CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASSWD';
GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';
FLUSH PRIVILEGES;
CREATE USER '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWD';
GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT


sudo sed -i 's/bind-address		= 127.0.0.1/bind-address		= 192.168.101.1/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql.service
