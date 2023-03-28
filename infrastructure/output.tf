output "instance_ip_addr" {
  value = azurerm_public_ip.main.ip_address
}
output "azureSQL" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "cassandra_endpoint" {
  value = azurerm_cosmosdb_account.main.endpoint 
}

output "cassandra_connectionstring" {
  value = azurerm_cosmosdb_account.main.connection_strings
  sensitive = true
}

output "rg_name" {
  value = azurerm_resource_group.main.name
}

output "rg_id" {
  value = azurerm_resource_group.main.id
  }

