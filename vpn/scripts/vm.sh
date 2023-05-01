#! /bin/bash
echo "insert ip : ";
read IP;
cd ../..

ssh -t -i ./vpn/ssh/id_rsa iusr@$IP '

if [[ ! -f /var/lib/apt/periodic/update-success-stamp ]] || \
   [[ $(find /var/lib/apt/periodic/update-success-stamp -mmin +60) ]]; then
  sudo apt-get update
fi

echo "installing chef workstation";
if [ -f "./chef-workstation_21.10.640-1_amd64.deb" ]; then
    echo "File exists"
else
    echo "File does not"
    wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb;
    sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb;
fi

if command -v chef-solo &> /dev/null
then
    echo "Chef is installed"
else
    echo "Chef is not installed"
    sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb;
fi


echo "downloading repo...";
if [ -d "./Proyecto-Redes" ]; then
    echo "Folder exists"
else
    echo "Folder does exists"
    git clone https://github.com/MrLuis137/Proyecto-Redes.git;
fi

cd Proyecto-Redes/vpn/chef-repo/;

echo "insert user name : ";
read USER_NAME;

echo "insert ip : ";
read IP;

JSON_CONTENT="{
    \"run_list\":[
        \"recipe[openvpn::enable_ip_forwarding]\",
        \"recipe[openvpn::server]\",
        \"recipe[openvpn::easy_rsa]\",
        \"recipe[openvpn::users]\"
    ],
    \"openvpn\":{
        \"gateway\": \"$IP\",
        \"push_options\": {
            \"dhcp-option\":[\"DNS 8.8.8.8\"],
            \"redirect-gateway\":[\"autolocal\"]
        },
        \"config\": {
            \"port\":443,
            \"proto\":\"tcp\"
        },
        \"key\": {
            \"ca_expire\": 3000
        }
    }
}"

echo "saving node.json"
echo $JSON_CONTENT > node.json;
cat node.json;

echo "saving solo.rb"
echo "current_dir = File.expand_path(File.dirname(__FILE__))
file_cache_path \"#{current_dir}\"
cookbook_path \"#{current_dir}/cookbooks\"
role_path \"#{current_dir}/roles\"
data_bag_path \"#{current_dir}/data_bags\"" > solo.rb;
cat solo.rb;

if [ -d "./data_bags/users" ]; then
    echo "Folder data_bags/users exists"
else
    echo "Folder data_bags/users does exists"
    #mkdir data_bags/users;
fi

echo "
{
   \"id\":\"$USER_NAME\",
   \"key_country\":\"US\",
   \"key_province\": \"VA\",
   \"key_city\": \"Herndon\",
   \"key_email\": \"$USER_NAME@email.com\",
   \"key_size\": 2048,
   \"key_org\": \"TEC\",
   \"key_org_unit\": \"computación\"
}
" > data_bags/users/$USER_NAME.json;
cat data_bags/users/$USER_NAME.json;

echo "running chef-solo...";

#if [ -f /lib/systemd/system/openvpn.service ]; then
    #echo "OpenVPN is installed."
#else
    #echo "OpenVPN is not installed."
    sudo chef-solo -c solo.rb -j node.json;
#fi

echo "done chef-solo...";

sudo cp /etc/openvpn/keys/vpn-prod-$USER_NAME.ovpn .;
sed -E -i -e "/^(ca|cert|key)/d" vpn-prod-$USER_NAME.ovpn;

echo "<ca>" >> vpn-prod-$USER_NAME.ovpn;
sudo cat /etc/openvpn/keys/ca.crt >> vpn-prod-$USER_NAME.ovpn;
echo "</ca>" >> vpn-prod-$USER_NAME.ovpn;

echo "<cert>" >> vpn-prod-$USER_NAME.ovpn;
sudo cat /etc/openvpn/keys/$USER_NAME.crt >> vpn-prod-$USER_NAME.ovpn;
echo "</cert>" >> vpn-prod-$USER_NAME.ovpn;

echo "<key>" >> vpn-prod-$USER_NAME.ovpn;
sudo cat /etc/openvpn/keys/$USER_NAME.key >> vpn-prod-$USER_NAME.ovpn;
echo "</key>" >> vpn-prod-$USER_NAME.ovpn; 

sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE;

cat vpn-prod-$USER_NAME.ovpn; 
'
