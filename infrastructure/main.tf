resource "azurerm_resource_group" "main" {
  name     = "ic7602-${var.group}"
  location = var.location["name"]
<<<<<<< HEAD
 }

# resource "azurerm_virtual_network" "vnetwork" {
#   name                = "${var.group}-network"
#   address_space       = ["10.0.0.0/8"]
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
# }

# resource "azurerm_subnet" "subred1" {
#   name                 = "subred1"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.vnetwork.name
#   address_prefixes     = ["10.0.0.0/22"]
# }

# resource "azurerm_subnet" "subred2" {
#   name                 = "subred2"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.vnetwork.name
#   address_prefixes     = ["10.0.4.0/22"]
# }

# resource "azurerm_subnet" "subred3" {
#   name                 = "subred3"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.vnetwork.name
#   address_prefixes     = ["10.0.8.0/22"]
# }


# resource "azurerm_network_security_group" "main" {
#   name                = "main-sg"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   security_rule {
#     name                       = "OutboundUDP"
#     priority                   = 100
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Udp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Outbound443"
#     priority                   = 101
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Outbound80"
#     priority                   = 102
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Outbound22"
#     priority                   = 106
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Inbound443"
#     priority                   = 104
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Inbound80"
#     priority                   = 105
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Inbound22"
#     priority                   = 107
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

  

# }

# resource "azurerm_subnet_network_security_group_association" "subred1" {
#     subnet_id                 = azurerm_subnet.subred1.id
#     network_security_group_id = azurerm_network_security_group.main.id
#   }

#   resource "azurerm_subnet_network_security_group_association" "subred2" {
#     subnet_id                 = azurerm_subnet.subred2.id
#     network_security_group_id = azurerm_network_security_group.main.id
#   }

#   resource "azurerm_subnet_network_security_group_association" "subred3" {
#     subnet_id                 = azurerm_subnet.subred3.id
#     network_security_group_id = azurerm_network_security_group.main.id
#   }


#  resource "azurerm_public_ip" "nat1" {
#    name                = "${var.group}-ip"
#    resource_group_name = azurerm_resource_group.main.name
#    location            = azurerm_resource_group.main.location
#    allocation_method   = "Static" 
#  }

#  resource "azurerm_nat_gateway" "nat1" {
#    name                    = "nat1"
#    location                = azurerm_resource_group.main.location
#    resource_group_name     = azurerm_resource_group.main.name
#    sku_name                = "Standard"
#    idle_timeout_in_minutes = 10
#    zones                   = ["1"]
#  }


#  resource "azurerm_nat_gateway_public_ip_association" "nat1" {
#    nat_gateway_id       = azurerm_nat_gateway.nat1.id
#    public_ip_address_id = azurerm_public_ip.nat1.id
#  }


#  resource "azurerm_subnet_nat_gateway_association" "subred1" {
#    subnet_id      = azurerm_subnet.subred1.id
#    nat_gateway_id = azurerm_nat_gateway.nat1.id
#  }

#  resource "azurerm_subnet_nat_gateway_association" "subred2" {
#    subnet_id      = azurerm_subnet.subred2.id
#    nat_gateway_id = azurerm_nat_gateway.nat1.id
#  }
#  resource "azurerm_subnet_nat_gateway_association" "subred3" {
#    subnet_id      = azurerm_subnet.subred3.id
#    nat_gateway_id = azurerm_nat_gateway.nat1.id
#  }



# resource "azurerm_route_table" "subred1" {
#   name                = "subred1-routetable"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   route {
#     name                   = "route-subred2"
#     address_prefix         = "10.0.4.0/22"
#     next_hop_type          = "None"
#   }
# }

# resource "azurerm_subnet_route_table_association" "subred1" {
#   subnet_id      = azurerm_subnet.subred1.id
#   route_table_id = azurerm_route_table.subred1.id
# }


# //_____________________________________________________________________________________
# //VM1
# //_____________________________________________________________________________________

# resource "azurerm_public_ip" "vm1" { 
#   name                = "vm1-ip" 
#   resource_group_name = azurerm_resource_group.main.name 
#   location            = azurerm_resource_group.main.location 
#   allocation_method   = "Static" 
# } 

# resource "azurerm_network_interface" "subred1" {
#   name                = "${var.group}-nic1"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   depends_on = [
#     azurerm_public_ip.vm1
#   ]
#   ip_configuration {
#     name                          = "main"
#     subnet_id                     = azurerm_subnet.subred1.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.vm1.id
#   }
# }

# data "template_file" "linux-vm-cloud-init" {
#   template = file("chef-dns.sh")
# }

# resource "azurerm_virtual_machine" "vm1" {
#   name                  = "${var.group}-vm1"
#   location              = azurerm_resource_group.main.location
#   resource_group_name   = azurerm_resource_group.main.name
#   network_interface_ids = [azurerm_network_interface.subred1.id]
#   vm_size               = "Standard_B1s"
#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "${var.group}vm1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = true
#     ssh_keys {
#       key_data = file("./ssh/id_rsa.pub") 
#       path = "/home/iusr/.ssh/authorized_keys"
#     }
#   }
#  os_profile {
#    computer_name = "vm1"
#    admin_username = "iusr"
#    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  
#  }


# }



//_____________________________________________________________________________________
//VM2
//_____________________________________________________________________________________

# resource "azurerm_network_interface" "subred2" {
#   name                = "${var.group}-nic2"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   depends_on = [
#     azurerm_public_ip.nat1
#   ]
#   ip_configuration {
#     name                          = "main"
#     subnet_id                     = azurerm_subnet.subred2.id
#     private_ip_address_allocation = "Dynamic"
#     //public_ip_address_id = azurerm_public_ip.nat1.id
#   }
# }

# # data "template_file" "linux-vm-cloud-init" {
# #   template = file("azure-user-data.sh")
# # }

# resource "azurerm_virtual_machine" "vm2" {
#   name                  = "${var.group}-vm2"
#   location              = azurerm_resource_group.main.location
#   resource_group_name   = azurerm_resource_group.main.name
#   network_interface_ids = [azurerm_network_interface.subred2.id]
#   vm_size               = "Standard_B1s"
#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "19_10-daily-gen2"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "${var.group}vm2"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = true
#     ssh_keys {
#       key_data = file("./ssh/id_rsa.pub") 
#       path = "/home/iusr/.ssh/authorized_keys"
#     }
#   }
#  os_profile {
#    computer_name = "${var.group}"
#    admin_username = "iusr"
#     custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
#  }

# }
# //_____________________________________________________________________________________
# //VM3
# //_____________________________________________________________________________________

# resource "azurerm_network_interface" "subred3" {
#   name                = "${var.group}-nic3"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   depends_on = [
#     azurerm_public_ip.nat1
#   ]
#   ip_configuration {
#     name                          = "main"
#     subnet_id                     = azurerm_subnet.subred3.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = ""//azurerm_public_ip.nat1.id
#   }
# }

# # data "template_file" "linux-vm-cloud-init" {
# #   template = file("azure-user-data.sh")
# # }

# resource "azurerm_virtual_machine" "vm3" {
#   name                  = "${var.group}-vm3"
#   location              = azurerm_resource_group.main.location
#   resource_group_name   = azurerm_resource_group.main.name
#   network_interface_ids = [azurerm_network_interface.subred3.id]
#   vm_size               = "Standard_B1s"
#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "19_10-daily-gen2"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "${var.group}vm3"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = true
#     ssh_keys {
#       key_data = file("./ssh/id_rsa.pub") 
#       path = "/home/iusr/.ssh/authorized_keys"
#     }
#   }
#  os_profile {
#    computer_name = "${var.group}"
#    admin_username = "iusr"
#     custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
#  }

# }

// ______________________________________________________________________________
//                                Firewall
//_______________________________________________________________________________

/*


resource "azurerm_network_security_group" "firewall" {
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

//Se asocia el firewall con las redes

resource "azurerm_subnet_network_security_group_association" "subnet1-firewall" {
  subnet_id                 = azurerm_subnet.subred1.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}

resource "azurerm_subnet_network_security_group_association" "subnet2-firewall" {
  subnet_id                 = azurerm_subnet.subred1.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}

resource "azurerm_subnet_network_security_group_association" "subnet3-firewall" {
  subnet_id                 = azurerm_subnet.subred1.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}*/

// ______________________________________________________________________________
//                                load balancer
//_______________________________________________________________________________

// https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-powershell

// should to create a new one because 
// this load balancer and the NAT gateway can not share a public ip
# resource "azurerm_public_ip" "publicIPForLoadBalancer" {
#   name                = "${var.group}-ip-lb"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   allocation_method   = "Static" 
#   sku                 = "Standard"
#   zones               = ["1"]
# }

# resource "azurerm_lb" "myLoadBalancer" {
#   name                  = "${var.group}-myLoadBalancer"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.publicIPForLoadBalancer.id 
#   }
# }

# resource "azurerm_lb_backend_address_pool" "myLoadBalancerBackendAddress" {
#   loadbalancer_id = azurerm_lb.myLoadBalancer.id
#   name            = "${var.group}-myLoadBalancerBackendAddress"
# }

# resource "azurerm_network_interface_backend_address_pool_association" "interfaceBackedLoadBalancer1" {
#   network_interface_id    = azurerm_network_interface.subred1.id
#   ip_configuration_name   = "main"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.myLoadBalancerBackendAddress.id
# }
# resource "azurerm_network_interface_backend_address_pool_association" "interfaceBackedLoadBalancer2" {
#   network_interface_id    = azurerm_network_interface.subred2.id
#   ip_configuration_name   = "main"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.myLoadBalancerBackendAddress.id
# }
# resource "azurerm_network_interface_backend_address_pool_association" "interfaceBackedLoadBalancer3" {
#   network_interface_id    = azurerm_network_interface.subred3.id
#   ip_configuration_name   = "main"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.myLoadBalancerBackendAddress.id
# }
=======
}
//
//resource "azurerm_virtual_network" "vnetwork" {
//  name                = "${var.group}-network"
//  address_space       = ["10.0.0.0/8"]
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//}
//
//resource "azurerm_subnet" "subred1" {
//  name                 = "subred1"
//  resource_group_name  = azurerm_resource_group.main.name
//  virtual_network_name = azurerm_virtual_network.vnetwork.name
//  address_prefixes     = ["10.0.0.0/22"]
//}
//
//resource "azurerm_subnet" "subred2" {
//  name                 = "subred2"
//  resource_group_name  = azurerm_resource_group.main.name
//  virtual_network_name = azurerm_virtual_network.vnetwork.name
//  address_prefixes     = ["10.0.4.0/22"]
//}
//
//resource "azurerm_subnet" "subred3" {
//  name                 = "subred3"
//  resource_group_name  = azurerm_resource_group.main.name
//  virtual_network_name = azurerm_virtual_network.vnetwork.name
//  address_prefixes     = ["10.0.8.0/22"]
//}
//
//
//resource "azurerm_network_security_group" "main" {
//  name                = "main-sg"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//
//  security_rule {
//    name                       = "OutboundUDP"
//    priority                   = 100
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Udp"
//    source_port_range          = "*"
//    destination_port_range     = "*"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Outbound443"
//    priority                   = 101
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "443"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Outbound80"
//    priority                   = 102
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "80"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Outbound22"
//    priority                   = 106
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "22"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Inbound443"
//    priority                   = 104
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "443"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Inbound80"
//    priority                   = 105
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "80"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Inbound22"
//    priority                   = 107
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "22"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  
//
//}
//
//resource "azurerm_subnet_network_security_group_association" "subred1" {
//    subnet_id                 = azurerm_subnet.subred1.id
//    network_security_group_id = azurerm_network_security_group.main.id
//  }
//
//  resource "azurerm_subnet_network_security_group_association" "subred2" {
//    subnet_id                 = azurerm_subnet.subred2.id
//    network_security_group_id = azurerm_network_security_group.main.id
//  }
//
//  resource "azurerm_subnet_network_security_group_association" "subred3" {
//    subnet_id                 = azurerm_subnet.subred3.id
//    network_security_group_id = azurerm_network_security_group.main.id
//  }
//
//
//resource "azurerm_public_ip" "nat1" {
//  name                = "${var.group}-ip"
//  resource_group_name = azurerm_resource_group.main.name
//  location            = azurerm_resource_group.main.location
//  #allocation_method   = "Dynamic"
//
//  tags = {
//    environment = "dev"
//  }
//  allocation_method   = "Dynamic" 
//  sku                 = "Basic"
//  zones               = ["1"]
//}
//
//resource "azurerm_nat_gateway" "nat1" {
//  name                    = "nat1"
//  location                = azurerm_resource_group.main.location
//  resource_group_name     = azurerm_resource_group.main.name
//  sku_name                = "Standard"
//  idle_timeout_in_minutes = 10
//  zones                   = ["1"]
//}
//
//
//resource "azurerm_nat_gateway_public_ip_association" "nat1" {
//  nat_gateway_id       = azurerm_nat_gateway.nat1.id
//  public_ip_address_id = azurerm_public_ip.nat1.id
//}
//
//
//resource "azurerm_subnet_nat_gateway_association" "subred1" {
//  subnet_id      = azurerm_subnet.subred1.id
//  nat_gateway_id = azurerm_nat_gateway.nat1.id
//}
//
//resource "azurerm_subnet_nat_gateway_association" "subred2" {
//  subnet_id      = azurerm_subnet.subred2.id
//  nat_gateway_id = azurerm_nat_gateway.nat1.id
//}
//
//resource "azurerm_subnet_nat_gateway_association" "subred3" {
//  subnet_id      = azurerm_subnet.subred3.id
//  nat_gateway_id = azurerm_nat_gateway.nat1.id
//}
//
//
//
//resource "azurerm_route_table" "subred1" {
//  name                = "subred1-routetable"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//
//  route {
//    name                   = "route-subred2"
//    address_prefix         = "10.0.4.0/22"
//    next_hop_type          = "None"
//  }
//}
//
//resource "azurerm_subnet_route_table_association" "subred1" {
//  subnet_id      = azurerm_subnet.subred1.id
//  route_table_id = azurerm_route_table.subred1.id
//}
//
//
////_____________________________________________________________________________________
////VM1
////_____________________________________________________________________________________
//
//resource "azurerm_network_interface" "subred1" {
//  name                = "${var.group}-nic1"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//  depends_on = [
//    azurerm_public_ip.nat1
//  ]
//  ip_configuration {
//    name                          = "main"
//    subnet_id                     = azurerm_subnet.subred1.id
//    private_ip_address_allocation = "Dynamic"
//    public_ip_address_id = azurerm_public_ip.nat1.id
//  }
//}
//
//data "template_file" "linux-vm-cloud-init" {
//  template = file("azure-user-data.sh")
//}
//
//resource "azurerm_virtual_machine" "vm1" {
//  name                  = "${var.group}-vm1"
//  location              = azurerm_resource_group.main.location
//  resource_group_name   = azurerm_resource_group.main.name
//  network_interface_ids = [azurerm_network_interface.subred1.id]
//  vm_size               = "Standard_B1s"
//  storage_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "19_10-daily-gen2"
//    version   = "latest"
//  }
//  storage_os_disk {
//    name              = "${var.group}vm1"
//    caching           = "ReadWrite"
//    create_option     = "FromImage"
//    managed_disk_type = "Standard_LRS"
//  }
//  os_profile_linux_config {
//    disable_password_authentication = true
//    ssh_keys {
//      key_data = file("./ssh/id_rsa.pub") 
//      path = "/home/iusr/.ssh/authorized_keys"
//    }
//  }
// os_profile {
//   computer_name = "${var.group}"
//   admin_username = "iusr"
//   custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
//   admin_password = "123456" # Contraseña para la cuenta de administrador de la máquina virtual
// }
//
//
//  /*provisioner "remote-exec" {
//
//    connection {
//      type        = "ssh"
//      host        = azurerm_network_interface.subred1.ip_configuration[3] # Dirección IP pública de la máquina virtual
//      user        = "iusr" # Nombre de usuario para la conexión SSH, obtenido del atributo os_profile.admin_username de la máquina virtual
//      password    = "123456" # Contraseña para la conexión SSH, obtenida del atributo os_profile.admin_password de la máquina virtual
//      
//    }
//
//    inline = [
//      "sudo apt-get update",
//      "sudo apt-get install -y curl",
//      "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk",
//      "echo 'Copying chef-repo'",
//      "sudo cp -R /D:/Proyecto-Redes/infrastructure/chef-repo /etc/chef/chef-repo",  # Ruta local de la carpeta chef-repo en tu máquina local
//      "sudo chef-solo -c /etc/chef/chef-repo/solo.rb -j /etc/chef/chef-repo/node.json"
//    ]
//  }*/
//
//
//}
//
//
//
////_____________________________________________________________________________________
////VM2
////_____________________________________________________________________________________
//
//resource "azurerm_network_interface" "subred2" {
//  name                = "${var.group}-nic2"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//  depends_on = [
//    azurerm_public_ip.nat1
//  ]
//  ip_configuration {
//    name                          = "main"
//    subnet_id                     = azurerm_subnet.subred2.id
//    private_ip_address_allocation = "Dynamic"
//    //public_ip_address_id = azurerm_public_ip.nat1.id
//  }
//}
//
//# data "template_file" "linux-vm-cloud-init" {
//#   template = file("azure-user-data.sh")
//# }
//
//resource "azurerm_virtual_machine" "vm2" {
//  name                  = "${var.group}-vm2"
//  location              = azurerm_resource_group.main.location
//  resource_group_name   = azurerm_resource_group.main.name
//  network_interface_ids = [azurerm_network_interface.subred2.id]
//  vm_size               = "Standard_B1s"
//  storage_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "19_10-daily-gen2"
//    version   = "latest"
//  }
//  storage_os_disk {
//    name              = "${var.group}vm2"
//    caching           = "ReadWrite"
//    create_option     = "FromImage"
//    managed_disk_type = "Standard_LRS"
//  }
//  os_profile_linux_config {
//    disable_password_authentication = true
//    ssh_keys {
//      key_data = file("./ssh/id_rsa.pub") 
//      path = "/home/iusr/.ssh/authorized_keys"
//    }
//  }
// os_profile {
//   computer_name = "${var.group}"
//   admin_username = "iusr"
//    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
// }
//
//}
////_____________________________________________________________________________________
////VM3
////_____________________________________________________________________________________
//
//resource "azurerm_network_interface" "subred3" {
//  name                = "${var.group}-nic3"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//  depends_on = [
//    azurerm_public_ip.nat1
//  ]
//  ip_configuration {
//    name                          = "main"
//    subnet_id                     = azurerm_subnet.subred3.id
//    private_ip_address_allocation = "Dynamic"
//    public_ip_address_id = ""//azurerm_public_ip.nat1.id
//  }
//}
//
//# data "template_file" "linux-vm-cloud-init" {
//#   template = file("azure-user-data.sh")
//# }
//
//resource "azurerm_virtual_machine" "vm3" {
//  name                  = "${var.group}-vm3"
//  location              = azurerm_resource_group.main.location
//  resource_group_name   = azurerm_resource_group.main.name
//  network_interface_ids = [azurerm_network_interface.subred3.id]
//  vm_size               = "Standard_B1s"
//  storage_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "19_10-daily-gen2"
//    version   = "latest"
//  }
//  storage_os_disk {
//    name              = "${var.group}vm3"
//    caching           = "ReadWrite"
//    create_option     = "FromImage"
//    managed_disk_type = "Standard_LRS"
//  }
//  os_profile_linux_config {
//    disable_password_authentication = true
//    ssh_keys {
//      key_data = file("./ssh/id_rsa.pub") 
//      path = "/home/iusr/.ssh/authorized_keys"
//    }
//  }
// os_profile {
//   computer_name = "${var.group}"
//   admin_username = "iusr"
//    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
// }
//
//}
//
//// ______________________________________________________________________________
////                                Firewall
////_______________________________________________________________________________
//
///*
//
//
//resource "azurerm_network_security_group" "firewall" {
//  name                = "main-sg"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//
//  security_rule {
//    name                       = "OutboundUDP"
//    priority                   = 100
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Udp"
//    source_port_range          = "*"
//    destination_port_range     = "*"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Outbound443"
//    priority                   = 101
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "443"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Outbound80"
//    priority                   = 102
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "80"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Outbound22"
//    priority                   = 106
//    direction                  = "Outbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "22"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Inbound443"
//    priority                   = 104
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "443"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Inbound80"
//    priority                   = 105
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "80"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  security_rule {
//    name                       = "Inbound22"
//    priority                   = 107
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "22"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//
//  
//
//}
//
////Se asocia el firewall con las redes
//
//resource "azurerm_subnet_network_security_group_association" "subnet1-firewall" {
//  subnet_id                 = azurerm_subnet.subred1.id
//  network_security_group_id = azurerm_network_security_group.firewall.id
//}
//
//resource "azurerm_subnet_network_security_group_association" "subnet2-firewall" {
//  subnet_id                 = azurerm_subnet.subred1.id
//  network_security_group_id = azurerm_network_security_group.firewall.id
//}
//
//resource "azurerm_subnet_network_security_group_association" "subnet3-firewall" {
//  subnet_id                 = azurerm_subnet.subred1.id
//  network_security_group_id = azurerm_network_security_group.firewall.id
//}*/
//
//// ______________________________________________________________________________
////                                load balancer
////_______________________________________________________________________________
//
//// https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-powershell
//
//// should to create a new one because 
//// this load balancer and the NAT gateway can not share a public ip
//resource "azurerm_public_ip" "publicIPForLoadBalancer" {
//  name                = "${var.group}-ip-lb"
//  resource_group_name = azurerm_resource_group.main.name
//  location            = azurerm_resource_group.main.location
//  allocation_method   = "Static" 
//  sku                 = "Standard"
//  zones               = ["1"]
//}
//
//resource "azurerm_lb" "myLoadBalancer" {
//  name                  = "${var.group}-myLoadBalancer"
//  location            = azurerm_resource_group.main.location
//  resource_group_name = azurerm_resource_group.main.name
//  sku                 = "Standard"
//
//  frontend_ip_configuration {
//    name                 = "PublicIPAddress"
//    public_ip_address_id = azurerm_public_ip.publicIPForLoadBalancer.id 
//  }
//}
//
//resource "azurerm_lb_backend_address_pool" "myLoadBalancerBackendAddress" {
//  loadbalancer_id = azurerm_lb.myLoadBalancer.id
//  name            = "${var.group}-myLoadBalancerBackendAddress"
//}
//
//resource "azurerm_network_interface_backend_address_pool_association" "interfaceBackedLoadBalancer1" {
//  network_interface_id    = azurerm_network_interface.subred1.id
//  ip_configuration_name   = "main"
//  backend_address_pool_id = azurerm_lb_backend_address_pool.myLoadBalancerBackendAddress.id
//}
//resource "azurerm_network_interface_backend_address_pool_association" "interfaceBackedLoadBalancer2" {
//  network_interface_id    = azurerm_network_interface.subred2.id
//  ip_configuration_name   = "main"
//  backend_address_pool_id = azurerm_lb_backend_address_pool.myLoadBalancerBackendAddress.id
//}
//resource "azurerm_network_interface_backend_address_pool_association" "interfaceBackedLoadBalancer3" {
//  network_interface_id    = azurerm_network_interface.subred3.id
//  ip_configuration_name   = "main"
//  backend_address_pool_id = azurerm_lb_backend_address_pool.myLoadBalancerBackendAddress.id
//}



//---------------------------------------------------------------------
// PROXY REVERSO
//---------------------------------------------------------------------
resource "azurerm_resource_group" "reverse_proxy" {
  name     = "ic7602-reverse-proxy"
  location = var.location["name"]
}

resource "azurerm_virtual_network" "reverse_proxy" {
  name                = "reverse-proxy-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.reverse_proxy.location
  resource_group_name = azurerm_resource_group.reverse_proxy.name
}

resource "azurerm_subnet" "reverse_proxy" {
  name                 = "main"
  resource_group_name  = azurerm_resource_group.reverse_proxy.name
  virtual_network_name = azurerm_virtual_network.reverse_proxy.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "reverse_proxy" {
  name                = "reverse-proxy-ip"
  resource_group_name = azurerm_resource_group.reverse_proxy.name
  location            = azurerm_resource_group.reverse_proxy.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "reverse_proxy" {
  name                = "reverse-proxy-nic"
  location            = azurerm_resource_group.reverse_proxy.location
  resource_group_name = azurerm_resource_group.reverse_proxy.name
  depends_on = [
    azurerm_public_ip.reverse_proxy
  ]
  ip_configuration {
    name                          = "main"
    subnet_id                     = azurerm_subnet.reverse_proxy.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.reverse_proxy.id
  }
}

data "template_file" "proxy-vm-cloud-init" {
   template = file("chef-reverse-proxy.sh")
 }

resource "azurerm_virtual_machine" "reverse_proxy" {
  name                  = "reverse-proxyvm"
  location              = azurerm_resource_group.reverse_proxy.location
  resource_group_name   = azurerm_resource_group.reverse_proxy.name
  network_interface_ids = [azurerm_network_interface.reverse_proxy.id]
  vm_size               = "Standard_b2s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "reverse-proxyvm"
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
    computer_name = "reverse-proxy"
    admin_username = "iusr"
    custom_data = base64encode(data.template_file.proxy-vm-cloud-init.rendered)
  }
}

//---------------------------------------------------------------------
// PROXY REVERSO
//---------------------------------------------------------------------
>>>>>>> master



//--------------------------------------------------------------------- 
// DNS 
//--------------------------------------------------------------------- 
 
resource "azurerm_resource_group" "dns" { 
  name     = "ic7602-dns" 
  location = var.location["name"] 
} 
 
resource "azurerm_virtual_network" "dns" { 
  name                = "dns-network" 
  address_space       = ["10.0.0.0/16"] 
  location            = azurerm_resource_group.main.location 
  resource_group_name = azurerm_resource_group.main.name 
} 
 
resource "azurerm_subnet" "dns" { 
  name                 = "main" 
  resource_group_name  = azurerm_resource_group.main.name 
  virtual_network_name = azurerm_virtual_network.dns.name 
  address_prefixes     = ["10.0.2.0/24"] 
} 
 
resource "azurerm_public_ip" "dns" { 
  name                = "dns-ip" 
  resource_group_name = azurerm_resource_group.main.name 
  location            = azurerm_resource_group.main.location 
  allocation_method   = "Static" 
} 
 
resource "azurerm_network_interface" "dns" { 
  name                = "dns-nic" 
  location            = azurerm_resource_group.main.location 
  resource_group_name = azurerm_resource_group.main.name 
  depends_on = [ 
    azurerm_public_ip.dns 
  ] 
  ip_configuration { 
    name                          = "main" 
    subnet_id                     = azurerm_subnet.dns.id 
    private_ip_address_allocation = "Dynamic" 
    public_ip_address_id = azurerm_public_ip.dns.id 
  } 
} 
 
data "template_file" "proxy-vm-cloud-init" { 
   template = file("chef-dns.sh") 
 } 
 
resource "azurerm_virtual_machine" "dns" { 
  name                  = "dns-vm" 
  location              = azurerm_resource_group.main.location 
  resource_group_name   = azurerm_resource_group.main.name 
  network_interface_ids = [azurerm_network_interface.dns.id] 
  vm_size               = "Standard_b2s" 
  storage_image_reference { 
    publisher = "Canonical" 
    offer     = "UbuntuServer" 
    sku       = "18.04-LTS" 
    version   = "latest" 
  } 
  storage_os_disk { 
    name              = "dns-disk" 
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
    computer_name = "dns-test" 
    admin_username = "iusr" 
    custom_data = base64encode(data.template_file.proxy-vm-cloud-init.rendered) 
  } 
} 
 
//--------------------------------------------------------------------- 
// DNS
//--------------------------------------------------------------------- 
 