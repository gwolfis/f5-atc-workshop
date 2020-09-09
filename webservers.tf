# Create two webservers

# Create Web01 NIC
resource "azurerm_network_interface" "web01-nic" {
  name                = "student${local.setup.azure.student_number}-web01-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.webserver.web01_privip
    primary                       = true
  }

  tags = {
    name        = "student${local.setup.azure.student_number}-web01"
    environment = local.setup.azure.environment
  }
}

# Create Web02 NIC
resource "azurerm_network_interface" "web02-nic" {
  name                = "student${local.setup.azure.student_number}-web02-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.webserver.web02_privip
    primary                       = true
  }

  tags = {
    name        = "student${local.setup.azure.student_number}-web02"
    environment = local.setup.azure.environment
  }
}

# Onboard script the web01
locals {
  web01_custom_data = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
sleep 30
docker run -d -p 80:80 --net host --restart unless-stopped\
    -e F5DEMO_APP=website \
    -e F5DEMO_NODENAME="WEB01" \
    -e F5DEMO_COLOR=ed7b0c \
    --restart always \
    --name f5demoapp \
    f5devcentral/f5-demo-httpd:nginx
EOF
}

# Onboard script the web02
locals {
  web02_custom_data = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
sleep 30
docker run -d -p 80:80 --net host --restart unless-stopped\
    -e F5DEMO_APP=website \
    -e F5DEMO_NODENAME="WEB02" \
    -e F5DEMO_COLOR=0194d2 \
    --restart always \
    --name f5demoapp \
    f5devcentral/f5-demo-httpd:nginx
EOF
}

# Create VM web01
resource "azurerm_linux_virtual_machine" "web01" {
  name                            = "student${local.setup.azure.student_number}-web01"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.web01-nic.id]
  size                            = "Standard_B1ms"
  admin_username                  = local.setup.webserver.user_name
  admin_password                  = local.setup.webserver.user_password
  disable_password_authentication = false
  computer_name                   = "student${local.setup.azure.student_number}-web01"
  custom_data                     = base64encode(local.web01_custom_data)

  os_disk {
    name                 = "web01OsDisk"
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
    name              = "student${local.setup.azure.student_number}-web01"
    environment       = local.setup.azure.environment
    service_discovery = local.setup.webserver.service_discovery
  }
}

# Create VM web02
resource "azurerm_linux_virtual_machine" "web02" {
  name                            = "student${local.setup.azure.student_number}-web02"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.web02-nic.id]
  size                            = "Standard_B1ms"
  admin_username                  = local.setup.webserver.user_name
  admin_password                  = local.setup.webserver.user_password
  disable_password_authentication = false
  computer_name                   = "student${local.setup.azure.student_number}-web02"
  custom_data                     = base64encode(local.web02_custom_data)

  os_disk {
    name                 = "web02OsDisk"
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
    name              = "student${local.setup.azure.student_number}-web02"
    environment       = local.setup.azure.environment
    service_discovery = local.setup.webserver.service_discovery
  }
}