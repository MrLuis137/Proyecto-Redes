# Proyecto-Redes

# VPN 

1. correr comando :
```
terraform init
terraform apply --var-file=conf/group.tfvars
```
2. cuando se levanta la infraestructura, conectarse a la vm
```
ssh -i /infrastructure/ssh/id_rsa iusr@<<ip_vm>>
```
3. cuando se accede correr:
```
sudo -i
apt-get update
```
4. instalar chef workstation, **buscar la versión que corresponda**
```
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb

dpkg -i chef-workstation_21.10.640-1_amd64.deb

chef -v
```
5. crear chef-repo
```
chef generate repo chef-repo
```
6. instalar openvpn, **buscar la versión que corresponda**
```
cd chef-repo
cd cookbooks
wget https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33811/original/openvpn.tgz?1681731757
mv 'openvpn.tgz?1681731757' openvpn.tgz
tar -xvvzf openvpn.tgz
rm -rf openvpn.tgz 
```

7. instalar yum-epel, **buscar la versión que corresponda**
en cookbooks folder
```
get https://supermarket-production-cookbooks.s3.amazonaws.com/cookbook_versions/tarballs/33840/original/yum-epel.tgz?1681746106
mv 'yum-epel.tgz?1681746106' yum-epel.tgz
tar -xvvzf yum-epel.tgz
rm -rf yum-epel.tgz
```
8. crear node.json
en chef-repo folder
```
nano node.json
```

agregar el siguiente json
cambiar el ip con el que corresponde

```
{
	"run_list":[
		"recipe[openvpn::enable_ip_forwarding]",
		"recipe[openvpn::server]",
		"recipe[openvpn::easy_rsa]",
		"recipe[openvpn::users]"
	],
	"openvpn":{
		"gateway": "<<ip-vm>>",
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
```

9. crear solo.rb
en chef-repo folder
```
nano solo.rb
```

agregar la siguiente información
**cambiar lo necesario**
```
current_dir = File.expand_path(File.dirname(__FILE__))
file_cache_path "#{current_dir}"
cookbook_path "#{current_dir}/cookbooks"
role_path "#{current_dir}/roles"
data_bag_path "#{current_dir}/data_bags"
```

10. crear archivo de usuario
```
mkdir data_bags/users```
nano data_bags/users/<<nombre_de_usuario>>.json
```

agregar

 ```
{
	"id":"<<id>>",
	"key_country":"US",
	"key_province": "VA",
	"key_city": "Herndon",
	"key_email": "<<correo>>",
	"key_size": 2048,
	"key_org": "TEC",
	"key_org_unit": "computación"
}
```

11. correr comando en chef-repo folder
```
chef-solo -c solo.rb -j node.json
```
**tarda un poco**

12. crear certificado vpn-prod-<<nombre_de_usuario>>.ovpn
en ruta inicial
```
cp /etc/openvpn/keys/vpn-prod-<<nombre_de_usuario>>.ovpn .

sed -E -i -e '/^(ca|cert|key)/d' vpn-prod-<<nombre_de_usuario>>.ovpn

echo "<ca>" >> vpn-prod-<<nombre_de_usuario>>.ovpn
cat /etc/openvpn/keys/ca.crt >> vpn-prod-<<nombre_de_usuario>>.ovpn
echo "</ca>" >> vpn-prod-<<nombre_de_usuario>>.ovpn

echo "<cert>" >> vpn-prod-<<nombre_de_usuario>>.ovpn 
cat /etc/openvpn/keys/<<nombre_de_usuario>>.crt >> vpn-prod-<<nombre_de_usuario>>.ovpn
echo "</cert>" >> vpn-prod-<<nombre_de_usuario>>.ovpn

echo "<key>" >> vpn-prod-<<nombre_de_usuario>>.ovpn 
cat /etc/openvpn/keys/<<nombre_de_usuario>>.key >> vpn-prod-<<nombre_de_usuario>>.ovpn
echo "</key>" >> vpn-prod-<<nombre_de_usuario>>.ovpn 
```

13. correr comando
```
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
```

14. copiar certificado vpn-prod-<<nombre_de_usuario>>.ovpn de vm a local

15. cargarlo en el cliente openVPN Connect