#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
sudo echo '<!DOCTYPE html><html><head><title>First Web Page</title></head><body><h1>Hello World!</h1></body></html>' > /var/www/html/index.nginx-debian.html
