#!/usr/bin/env bash

#INSTALL THE CHEF SERVER

#Download the Chef Server core and install. 
wget https://packages.chef.io/files/stable/chef-server/15.1.7/ubuntu/20.04/chef-server-core_15.1.7-1_amd64.deb
sudo dpkg -i chef-server-core_*.deb
rm chef-server-core_*.deb

#Start the Chef server.
sudo chef-server-ctl reconfigure --chef-license=accept
sleep 15

#Create a directory to store the keys
mkdir /home/vagrant/.chef
sleep 5

#Create user and organisation for the Chef administrator.
sudo chef-server-ctl user-create hillel_chef Hillel Chef hillel@chef.com 'your_strong_password' --filename /home/vagrant/.chef/hillel_chef.pem
sleep 5
sudo chef-server-ctl org-create hillel_org "Hillel Chef" --association_user hillel_chef --filename /home/vagrant/.chef/hillel_org.pem
