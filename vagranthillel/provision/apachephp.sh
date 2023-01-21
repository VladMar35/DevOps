#!/usr/bin/env bash

sudo apt update
sudo apt install apache2 -y
sudo ufw allow 'Apache'

sudo apt install php libapache2-mod-php php-mysql php-dom -y
sudo systemctl restart apache2

sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo mv /home/vagrant/wordpress /var/www/html/example.com


