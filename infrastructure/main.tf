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

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.subred1.id
  route_table_id = azurerm_route_table.subred1.id
}