

output "rg_name" {
  value = azurerm_resource_group.main.name
}

output "rg_id" {
  value = azurerm_resource_group.main.id
}

output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}