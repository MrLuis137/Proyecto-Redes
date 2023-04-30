#! /bin/bash

# public IP from virtual machine deployed
IP="74.235.64.11"

# connect to VM
ssh -i /vpn/ssh/id_rsa iusr@$IP

# update
sudo -i
apt-get update

# download chef-workstation
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
dpkg -i chef-workstation_21.10.640-1_amd64.deb

# create chef repo
chef generate repo chef-repo

# install openvpn
cd chef-repo
cd cookbooks
wget https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33811/original/openvpn.tgz?1681731757
mv 'openvpn.tgz?1681731757' openvpn.tgz
tar -xvvzf openvpn.tgz
rm -rf openvpn.tgz 

# install yum-epel
get https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33840/original/yum-epel.tgz?1681746106
mv 'yum-epel.tgz?1681746106' yum-epel.tgz
tar -xvvzf yum-epel.tgz
rm -rf yum-epel.tgz