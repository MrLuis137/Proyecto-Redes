resource "azurerm_resource_group" "main" {
  name     = "ic7602-${var.group}"
  location = var.location["name"]
}

resource "azurerm_virtual_network" "vnetwork" {
  name                = "${var.group}-network"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subred1" {
  name                 = "subred1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = ["10.0.0.0/22"]
}

resource "azurerm_subnet" "subred2" {
  name                 = "subred2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = ["10.0.4.0/22"]
}

resource "azurerm_subnet" "subred3" {
  name                 = "subred3"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = ["10.0.8.0/22"]
}


resource "azurerm_network_security_group" "main" {
  name                = "main-sg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "OutboundUDP"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound443"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound80"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound22"
    priority                   = 106
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Inbound443"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Inbound80"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Inbound22"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  

}

resource "azurerm_subnet_network_security_group_association" "subred1" {
    subnet_id                 = azurerm_subnet.subred1.id
    network_security_group_id = azurerm_network_security_group.main.id
  }

  resource "azurerm_subnet_network_security_group_association" "subred2" {
    subnet_id                 = azurerm_subnet.subred2.id
    network_security_group_id = azurerm_network_security_group.main.id
  }

  resource "azurerm_subnet_network_security_group_association" "subred3" {
    subnet_id                 = azurerm_subnet.subred3.id
    network_security_group_id = azurerm_network_security_group.main.id
  }


resource "azurerm_public_ip" "nat1" {
  name                = "${var.group}-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static" 
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat1" {
  name                    = "nat1"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}


resource "azurerm_nat_gateway_public_ip_association" "nat1" {
  nat_gateway_id       = azurerm_nat_gateway.nat1.id
  public_ip_address_id = azurerm_public_ip.nat1.id
}


resource "azurerm_subnet_nat_gateway_association" "subred1" {
  subnet_id      = azurerm_subnet.subred1.id
  nat_gateway_id = azurerm_nat_gateway.nat1.id
}

resource "azurerm_subnet_nat_gateway_association" "subred2" {
  subnet_id      = azurerm_subnet.subred2.id
  nat_gateway_id = azurerm_nat_gateway.nat1.id
}

resource "azurerm_subnet_nat_gateway_association" "subred3" {
  subnet_id      = azurerm_subnet.subred3.id
  nat_gateway_id = azurerm_nat_gateway.nat1.id
}



resource "azurerm_route_table" "subred1" {
  name                = "subred1-routetable"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name                   = "route-subred2"
    address_prefix         = "10.0.4.0/22"
    next_hop_type          = "None"
  }
}

resource "azurerm_subnet_route_table_association" "subred1" {
  subnet_id      = azurerm_subnet.subred1.id
  route_table_id = azurerm_route_table.subred1.id
}


//_____________________________________________________________________________________
//VM1
//_____________________________________________________________________________________

resource "azurerm_network_interface" "subred1" {
  name                = "${var.group}-nic1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_public_ip.nat1
  ]
  ip_configuration {
    name                          = "main"
    subnet_id                     = azurerm_subnet.subred1.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id = azurerm_public_ip.nat1.id
  }
}

data "template_file" "linux-vm-cloud-init" {
  template = file("azure-user-data.sh")
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "${var.group}-vm1"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.subred1.id]
  vm_size               = "Standard_B1s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_10-daily-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.group}vm1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./ssh/id_rsa.pub") 
      path = "/home/iusr/.ssh/authorized_keys"
    }
  }
 os_profile {
   computer_name = "${var.group}"
   admin_username = "iusr"
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
 }

}

//_____________________________________________________________________________________
//VM2
//_____________________________________________________________________________________

resource "azurerm_network_interface" "subred2" {
  name                = "${var.group}-nic2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_public_ip.nat1
  ]
  ip_configuration {
    name                          = "main"
    subnet_id                     = azurerm_subnet.subred2.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id = azurerm_public_ip.nat1.id
  }
}

# data "template_file" "linux-vm-cloud-init" {
#   template = file("azure-user-data.sh")
# }

resource "azurerm_virtual_machine" "vm2" {
  name                  = "${var.group}-vm2"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.subred2.id]
  vm_size               = "Standard_B1s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_10-daily-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.group}vm2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./ssh/id_rsa.pub") 
      path = "/home/iusr/.ssh/authorized_keys"
    }
  }
 os_profile {
   computer_name = "${var.group}"
   admin_username = "iusr"
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
 }

}
//_____________________________________________________________________________________
//VM3
//_____________________________________________________________________________________

resource "azurerm_network_interface" "subred3" {
  name                = "${var.group}-nic3"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_public_ip.nat1
  ]
  ip_configuration {
    name                          = "main"
    subnet_id                     = azurerm_subnet.subred3.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id = azurerm_public_ip.nat1.id
  }
}

# data "template_file" "linux-vm-cloud-init" {
#   template = file("azure-user-data.sh")
# }

resource "azurerm_virtual_machine" "vm3" {
  name                  = "${var.group}-vm3"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.subred3.id]
  vm_size               = "Standard_B1s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_10-daily-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.group}vm3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./ssh/id_rsa.pub") 
      path = "/home/iusr/.ssh/authorized_keys"
    }
  }
 os_profile {
   computer_name = "${var.group}"
   admin_username = "iusr"
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
 }

}

// ______________________________________________________________________________
//                                Firewall
//_______________________________________________________________________________

resource "azurerm_firewall_network_rule_collection" "firewall" {
  name                = "firewall"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  priority            = 100
  

  //in rules
  rule {
    name                     = "SSH_IN_TCP_22"
    description              = "Allow inbound SSH traffic in port 22"
    source_addresses         = ["*"]
    destination_ports        = ["22"]
    destination_addresses    = ["*"]
    protocol                 = "TCP"
    access                   = "Allow"
    direction                = "Inbound"
    priority                 = 100
  }
  
  rule {
    name                     = "HTTP_IN_TCP_80"
    description              = "Allow inbound HTTP traffic in port 80"
    source_addresses         = ["*"]
    destination_ports        = ["80"]
    destination_addresses    = ["*"]
    protocol                 = "TCP"
    access                   = "Allow"
    direction                = "Inbound"
    priority                 = 101
  }
  
  rule {
    name                     = "HTTPS_IN_TCP_443"
    description              = "Allow inbound HTTPS traffic in port 443"
    source_addresses         = ["*"]
    destination_ports        = ["443"]
    destination_addresses    = ["*"]
    protocol                 = "TCP"
    access                   = "Allow"
    direction                = "Inbound"
    priority                 = 102
  }

  //out rules

  rule {
    name                     = "SSH_OUT_TCP_22"
    description              = "Allow outbound SSH traffic in port 22"
    source_addresses         = ["*"]
    destination_ports        = ["22"]
    destination_addresses    = ["*"]
    protocol                 = "TCP"
    access                   = "Allow"
    direction                = "Outbound"
    priority                 = 103
  }
  

  rule {
    name                     = "HTTP_OUT_TCP_80"
    description              = "Allow outbound HTTP trafficin port 80"
    source_addresses         = ["*"]
    destination_ports        = ["80"]
    destination_addresses    = ["*"]
    protocol                 = "TCP"
    access                   = "Allow"
    direction                = "Outbound"
    priority                 = 104
  }
  
  rule {
    name                     = "HTTPS_OUT_TCP_443"
    description              = "Allow outbound HTTPS traffic in port 443"
    source_addresses         = ["*"]
    destination_ports        = ["443"]
    destination_addresses    = ["*"]
    protocol                 = "TCP"
    access                   = "Allow"
    direction                = "Outbound"
    priority                 = 105
  }
  
  rule {
    name                     = "Allow_udp_out"
    description              = "Allow outbound UDP traffic"
    source_addresses         = ["*"]
    destination_ports        = ["*"]
    destination_addresses    = ["*"]
    protocol                 = "UDP"
    access                   = "Allow"
    direction                = "Outbound"
    priority                 = 106
  }
}


//Se asocia el firewall con las redes

resource "azurerm_subnet_network_security_group_association" "subnet1-firewall" {
  subnet_id                 = azurerm_subnet.subred1.id
  network_security_group_id = azurerm_firewall_network_rule_collection.firewall.id
}

resource "azurerm_subnet_network_security_group_association" "subnet2-firewall" {
  subnet_id                 = azurerm_subnet.subred1.id
  network_security_group_id = azurerm_firewall_network_rule_collection.firewall.id
}

resource "azurerm_subnet_network_security_group_association" "subnet3-firewall" {
  subnet_id                 = azurerm_subnet.subred1.id
  network_security_group_id = azurerm_firewall_network_rule_collection.firewall.id
}


