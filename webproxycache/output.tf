

output "instance_ip_addr" {
  value = azurerm_public_ip.main.ip_address
}
/**/

//sudo chef-solo  -c solo.rb -j node.json   20.51.172.105
// ". 30 50% 20160 override-expire ignore-no-store ignore-private"
//chmod +x /tmp/install.sh

//sudo tail -100 /var/log/squid/access.log
//sudo du -s