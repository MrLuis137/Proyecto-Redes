#! /bin/bash

IP="20.120.4.37"

JSON_CONTENT='
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
            "redire20.120.4.37ct-gateway":["autolocal"]
        },
        "config": {
            "port":443,
            "proto":"tcp"
        },
        "key": {
            "ca_expire": 3000
        }
    }
}'



echo "The value is: ${IP}"

echo "connecting to vm... in ${IP}"
cd ../..
ssh -t -i ./vpn/ssh/id_rsa iusr@$IP '
sudo apt-get update;
echo "installing chef workstation";
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb;
sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb;
chef -v;
echo "downloading repo...";
ls;
git clone https://github.com/MrLuis137/Proyecto-Redes.git;
cd Proyecto-Redes/vpn/chef-repo/;
ls;
echo "insert user name : ";
read USER_NAME;

echo "JSON_CONTENT" > nano.json;

echo "current_dir = File.expand_path(File.dirname(__FILE__))
file_cache_path \"#{current_dir}\"
cookbook_path \"#{current_dir}/cookbooks\"
role_path \"#{current_dir}/roles\"
data_bag_path \"#{current_dir}/data_bags\"" > solo.rb;

mkdir data_bags/users;
nano data_bags/users/$USER_NAME.json;
echo "{
   \"id":\"$USER_NAME\",
   \"key_country\":\"US\",
   \"key_province\": \"VA\",
   \"key_city\": \"Herndon\",
   \"key_email\": \"$USER_NAME@email.com\",
   \"key_size\": 2048,
   \"key_org\": \"TEC\",
   \"key_org_unit\": \"computación\"
}" > solo.rb;
echo "running chef-solo...";
chef-solo -c solo.rb -j node.json;

cp /etc/openvpn/keys/vpn-prod-$USER_NAME.ovpn .;
sed -E -i -e "/^(ca|cert|key)/d" vpn-prod-$USER_NAME.ovpn;

echo \"<ca>\" >> vpn-prod-$USER_NAME.ovpn;
cat /etc/openvpn/keys/ca.crt >> vpn-prod-$USER_NAME.ovpn;
echo \"</ca>\" >> vpn-prod-$USER_NAME.ovpn;

echo \"<cert>\" >> vpn-prod-$USER_NAME.ovpn;
cat /etc/openvpn/keys/$USER_NAME.crt >> vpn-prod-$USER_NAME.ovpn;
echo \"</cert>\" >> vpn-prod-$USER_NAME.ovpn;

echo \"<key>\" >> vpn-prod-$USER_NAME.ovpn;
cat /etc/openvpn/keys/$USER_NAME.key >> vpn-prod-$USER_NAME.ovpn;
echo \"</key>\" >> vpn-prod-$USER_NAME.ovpn; 

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE;

cat vpn-prod-$USER_NAME.ovpn; 
'
