#! /bin/bash

# public IP from virtual machine deployed
IP="20.121.2.187"
USER_NAME="jarod"

# connect to VM
ssh -i ./vpn/ssh/id_rsa iusr@$IP

# update
sudo -i
apt-get update

# download chef-workstation
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
dpkg -i chef-workstation_21.10.640-1_amd64.deb

# download repo
git clone https://github.com/MrLuis137/Proyecto-Redes.git
cd Proyecto-Redes/vpn/

# create chef repo
chef generate repo chef-repo

# install openvpn
cd chef-repo/cookbooks/
wget https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33811/original/openvpn.tgz?1681731757
mv 'openvpn.tgz?1681731757' openvpn.tgz
tar -xvvzf openvpn.tgz
rm -rf openvpn.tgz 

# install yum-epel
wget https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33840/original/yum-epel.tgz?1681746106
mv 'yum-epel.tgz?1681746106' yum-epel.tgz
tar -xvvzf yum-epel.tgz
rm -rf yum-epel.tgz

# create node.json
cd ..
nano node.json

:<<'COMMENT'
{
    "run_list":[
        "recipe[openvpn::enable_ip_forwarding]",
        "recipe[openvpn::server]",
        "recipe[openvpn::easy_rsa]",
        "recipe[openvpn::users]"
    ],
    "openvpn":{
        "gateway": $IP,
        "push_options": {
            "dhcp-option":["DNS 8.8.8.8"],
            "redirect-gateway":["autolocal"]
        },
        "config": {
            "port":443,
            "proto":"tcp"
        },
        "key": {
            "ca_expire": 3000
        }
    }
}
COMMENT

# create solo.rb
nano solo.rb
:<<'COMMENT'
current_dir = File.expand_path(File.dirname(__FILE__))
file_cache_path "#{current_dir}"
cookbook_path "#{current_dir}/cookbooks"
role_path "#{current_dir}/roles"
data_bag_path "#{current_dir}/data_bags"
COMMENT

# create user file 
mkdir data_bags/users
nano data_bags/users/$USER_NAME.json
:<<'COMMENT'
{
   "id":"$USER_NAME",
   "key_country":"US",
   "key_province": "VA",
   "key_city": "Herndon",
   "key_email": "$USER_NAME@email.com",
   "key_size": 2048,
   "key_org": "TEC",
   "key_org_unit": "computación"
}
COMMENT

# run chef command
chef-solo -c solo.rb -j node.json

# create .ovpn file
cp /etc/openvpn/keys/vpn-prod-$USER_NAME.ovpn .
sed -E -i -e '/^(ca|cert|key)/d' vpn-prod-$USER_NAME.ovpn

echo "<ca>" >> vpn-prod-$USER_NAME.ovpn
cat /etc/openvpn/keys/ca.crt >> vpn-prod-$USER_NAME.ovpn
echo "</ca>" >> vpn-prod-$USER_NAME.ovpn

echo "<cert>" >> vpn-prod-$USER_NAME.ovpn 
cat /etc/openvpn/keys/$USER_NAME.crt >> vpn-prod-$USER_NAME.ovpn
echo "</cert>" >> vpn-prod-$USER_NAME.ovpn

echo "<key>" >> vpn-prod-$USER_NAME.ovpn 
cat /etc/openvpn/keys/$USER_NAME.key >> vpn-prod-$USER_NAME.ovpn
echo "</key>" >> vpn-prod-$USER_NAME.ovpn 

#
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE