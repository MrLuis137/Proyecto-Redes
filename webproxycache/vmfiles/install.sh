#! /bin/bash
cd ~
apt-get update
sudo apt-get update
sudo wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb
sudo chef generate repo chef-repo --chef-license accept
cd chef-repo/
cd cookbooks/
wget https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33030/original/squid.tgz?1676371807
sudo mv 'squid.tgz?1676371807' squid.tgz
sudo tar -xvvzf squid.tgz
sudo rm squid.tgz
cd ..
sudo mv /tmp/squid.conf.erb ~/chef-repo/cookbooks/squid/templates/default/squid.conf.erb
sudo mv /tmp/solo.rb ~/chef-repo/solo.rb
sudo mv /tmp/node.json ~/chef-repo/node.json
sudo chef-solo  -c solo.rb -j node.json