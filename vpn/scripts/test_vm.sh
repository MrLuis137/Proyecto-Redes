#! /bin/bash
IP="4.246.203.145"

# connect to VM
echo "connecting to vm..."
ssh -i /vpn/ssh/id_rsa iusr@$IP

echo "updating vm..."
sudo -i
apt-get update

echo "installing chef workstation"
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
dpkg -i chef-workstation_21.10.640-1_amd64.deb

echo "downloading repo..."
git clone https://github.com/MrLuis137/Proyecto-Redes.git
cd Proyecto-Redes/vpn/

ls