#! /bin/bash
echo "start script"
cd ..

echo "start terraform"
terraform init
echo "init done"

echo "start apply"
terraform apply --var-file=conf/group.tfvars -auto-approve
echo "apply done"
IP=$(terraform output -raw public_ip_address)

echo "The value is: ${IP}"

echo "connecting to vm..."
ssh -i /vpn/ssh/id_rsa iusr@$IP -c

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
