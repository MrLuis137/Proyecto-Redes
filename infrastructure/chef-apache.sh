#! /bin/bash
sudo apt-get update  
sudo apt-get install -y apache2
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb
cd /home/iusr
sudo chef generate repo chef-repo --chef-license accept
sudo git clone https://github.com/MrLuis137/Proyecto-Redes.git
cd Proyecto-redes/infrastructure/chef-repo
