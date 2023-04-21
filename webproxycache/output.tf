

output "instance_ip_addr" {
  value = azurerm_public_ip.main.ip_address
}
/**/

//sudo chef-solo  -c solo.rb -j node.json   137.117.58.166
// ". 30 50% 20160 override-expire ignore-no-store ignore-private"
//chmod +x /tmp/install.sh