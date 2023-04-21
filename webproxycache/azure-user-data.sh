#! /bin/bash
apt-get update
sudo apt-get update
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb
sudo chef generate repo chef-repo --chef-license accept
cd chef-repo/
cd cookbooks/
wget https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33030/original/squid.tgz?1676371807
sudo mv 'squid.tgz?1676371807' squid.tgz
sudo tar -xvvzf squid.tgz
sudo rm squid.tgz
cd ..
