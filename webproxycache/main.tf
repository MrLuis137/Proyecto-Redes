resource "azurerm_resource_group" "main" {
  name     = "ic7602-${var.group}"
  location = var.location["name"]
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.group}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "main"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "${var.group}-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "main" {
  name                = "${var.group}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_public_ip.main
  ]
  ip_configuration {
    name                          = "main"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-user-data.sh")
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.group}-server"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1s"
  provisioner "file" {
    source      = "vmfiles/squid.conf.erb"
    destination = "/tmp/squid.conf.erb"
    connection {
      type        = "ssh"
      user        = "iusr"
      password    = ""
      private_key  = file("./ssh/ubutu") 
      host        = azurerm_public_ip.main.ip_address
    }
  }
  provisioner "file" {
    source      = "vmfiles/solo.rb"
    destination = "/tmp/solo.rb"
    connection {
      type        = "ssh"
      user        = "iusr"
      password    = ""
      private_key  = file("./ssh/ubutu") 
      host        = azurerm_public_ip.main.ip_address
    }
  }
  provisioner "file" {
    source      = "vmfiles/node.json"
    destination = "/tmp/node.json"
    connection {
      type        = "ssh"
      user        = "iusr"
      password    = ""
      private_key  = file("./ssh/ubutu") 
      host        = azurerm_public_ip.main.ip_address
    }
  }
  provisioner "file" {
    source      = "vmfiles/install.sh"
    destination = "/tmp/install.sh"
    connection {
      type        = "ssh"
      user        = "iusr"
      password    = ""
      private_key  = file("./ssh/ubutu") 
      host        = azurerm_public_ip.main.ip_address
    }
  }
  provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/install.sh",
  ]
  connection {
      type        = "ssh"
      user        = "iusr"
      password    = ""
      private_key  = file("./ssh/ubutu") 
      host        = azurerm_public_ip.main.ip_address
  }
}
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.group}-vm1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./ssh/ubutu.pub") 
      path = "/home/iusr/.ssh/authorized_keys"
    }
  }
 os_profile {
   computer_name = "${var.group}"
   admin_username = "iusr"
   custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
 }


}



/*
provisioner "remote-exec" {
  inline = [
    "rm /home/iusr/chef-repo/cookbooks/squid/templates/default/squid.conf.erb",
    "mv /tmp/squid.conf.erb ~/chef-repo/cookbooks/squid/templates/default/squid.conf.erb ",
  ]
  connection {
    type        = "ssh"
    user        = "iusr"
    password    = ""
    host        = azurerm_virtual_machine.main.public_ip_address
  }
}
/**/