#!/usr/bin/env bash
#INSTALL A CHEF WORKSTATION
sudo apt update
#Download and Install the Chef Workstation.
wget https://packages.chef.io/files/stable/chef-workstation/22.10.1013/ubuntu/20.04/chef-workstation_22.10.1013-1_amd64.deb
sudo dpkg -i chef-workstation_*.deb
rm chef-workstation_*.deb
sleep 5

#Generate the chef-repo repository. This directory stores the Chef cookbooks and recipes.
chef generate repo chef-repo --chef-license=accept
sleep 10

#Edit the /etc/hosts file. This file contains mappings between host names and their IP addresses.
sudo sed -i '10 a192.168.10.100 server' /etc/hosts
sudo sed -i '11 a192.168.11.101 client' /etc/hosts
sudo sed -i '12 a192.168.12.102 node' /etc/hosts

#Create a .chef subdirectory. This is where the knife file is stored, along with files for encryption and security.
mkdir /home/vagrant/chef-repo/.chef
sleep 5

#Generate an RSA key pair.
ssh-keygen -t rsa -N '' -f /home/vagrant/.ssh/id_rsa <<< y
sleep 10

#Copy the new public key from the workstation to the Chef Server.
sudo apt install sshpass
sleep 5
sshpass -p "vagrant" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@192.168.10.100
sleep 5
sshpass -p "vagrant" scp vagrant@192.168.10.100:/home/vagrant/.chef/*.pem /home/vagrant/chef-repo/.chef
sleep 5

#Configure Git on a Chef Workstation for knife supermarket.
git config --global user.name hillel
git config --global user.email hillel@email.com
echo "chef" > /home/vagrant/chef-repo/.gitignore
sleep 5
cd /home/vagrant/chef-repo
git add .
git commit -m "initial commit"

#Configure the Knife Utility
cd /home/vagrant/chef-repo/.chef
wget https://raw.githubusercontent.com/vvmarchenko/DevOps/main/Chef/config.rb

#Fetch the necessary SSL certificates from the server.
cd ..
knife ssl fetch
knife client list

#Bootstrap the node using the knife bootstrap command.
knife bootstrap 192.168.12.102 -U vagrant -P vagrant --sudo --use-sudo-password --node-name node -y

#Download and Apply a Cookbook.
cd /home/vagrant/chef-repo/.chef
knife supermarket install mysql
mkdir /home/vagrant/chef-repo/cookbooks/mysql/recipes && cd /home/vagrant/chef-repo/cookbooks/mysql/recipes
wget https://raw.githubusercontent.com/vvmarchenko/DevOps/main/Chef/recipes/default.rb
sudo sed -i "10 adepends 'mysql'" /home/vagrant/chef-repo/cookbooks/mysql/metadata.rb

#Add the recipe to the run list for the node.
knife node run_list add node 'recipe[mysql::default]'
knife node run_list add node 'recipe[apparmor::default]'

#Upload the cookbooks and its recipes to the Chef Server.
sudo knife cookbook upload mysql --include-dependencies

#Pull the recipes in its run list from the server.
sudo knife ssh 'name:node' 'sudo chef-client' -x vagrant -P vagrant
