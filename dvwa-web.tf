# DVWA-Web Server

# Create DVWA NIC
resource "azurerm_network_interface" "dvwa-nic" {
  name                = "student${local.setup.azure.student_number}-dvwa-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.dvwa.dvwa_privip
    primary                       = true
  }

  tags = {
    name        = "student${local.setup.azure.student_number}-dvwa-web"
    environment = local.setup.azure.environment
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "dvwa-nsg-int" {
    network_interface_id      = azurerm_network_interface.dvwa-nic.id
    network_security_group_id = azurerm_network_security_group.intnsg.id
}

# Onboard script the DVWA server
locals {
  dvwa_custom_data = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
docker run -d -p 80:80 --net=host --restart unless-stopped vulnerables/web-dvwa
EOF
}

# Create VM
resource "azurerm_linux_virtual_machine" "dvwa-web" {
  name                            = "student${local.setup.azure.student_number}-dvwa-web"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.dvwa-nic.id]
  size                            = "Standard_B1ms"
  admin_username                  = local.setup.webserver.user_name
  admin_password                  = local.setup.webserver.user_password
  disable_password_authentication = false
  computer_name                   = "student${local.setup.azure.student_number}-dvwa-web"
  custom_data                     = base64encode(local.dvwa_custom_data)

  os_disk {
    name                 = "dvwaOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    name        = "student${local.setup.azure.student_number}-dvwa"
    environment = local.setup.azure.environment
  }
}