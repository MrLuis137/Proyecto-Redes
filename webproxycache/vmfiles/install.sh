#! /bin/bash
cd ~
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