# Create BIG-IP Public IP address
resource "azurerm_public_ip" "bigip02mgmtpip" {
    name                         = "student${local.setup.azure.student_number}-bigip02-mgmt-pip"
    location                     = local.setup.azure.location
    sku                          = "Standard"
    zones                        = [2]
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"

    tags = {
      Name        = "student${local.setup.azure.student_number}-bigip02-mgmt-pip"
      environment = local.setup.azure.environment
    }
}

resource "azurerm_public_ip" "bigip02selfextpip" {
    name                         = "student${local.setup.azure.student_number}-bigip02-self-ext-pip"
    location                     = local.setup.azure.location
    sku                          = "Standard"
    zones                        = [2]
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"

    tags = {
      Name        = "student${local.setup.azure.student_number}-bigip02-self-ext-pip"
      environment = local.setup.azure.environment
    }
}

resource "azurerm_public_ip" "bigip02-pubvippip" {
  name                = "student${local.setup.azure.student_number}-bigip02-pubvip-pip"
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  zones               = [2]
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"

  tags = {
    Name        = "student${local.setup.azure.student_number}-bigip02-pubvip-public-ip"
    environment = local.setup.azure.environment
  }
}


# Create NIC for Management 
resource "azurerm_network_interface" "bigip02-mgmt-nic" {
  name                = "student${local.setup.azure.student_number}-bigip02-mgmt0"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.bigip.bigip02_mgmt
    public_ip_address_id          = azurerm_public_ip.bigip02mgmtpip.id
  }

  tags = {
    Name        = "student${local.setup.azure.student_number}-bigip02-mgmt-int"
    environment = local.setup.azure.environment
  }
}

# Create external NIC
resource "azurerm_network_interface" "bigip02-ext-nic" {
  name                 = "student${local.setup.azure.student_number}-bigip02-ext0"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  enable_ip_forwarding = true 

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.bigip.bigip02_ext
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.bigip02selfextpip.id
  }

  ip_configuration {
    name                          = "secondary"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.bigip.bigip_vip02
    public_ip_address_id          = azurerm_public_ip.bigip02-pubvippip.id
  }

  tags = {
    name        = "student${local.setup.azure.student_number}-bigip02-ext-int"
    environment = local.setup.azure.environment
  }
}

# Create internal NIC
resource "azurerm_network_interface" "bigip02-int-nic" {
  name                 = "student${local.setup.azure.student_number}-bigip02-int0"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.setup.bigip.bigip02_int
    primary                       = true
  }

  tags = {
    name        = "student${local.setup.azure.student_number}-bigip02-int-int"
    environment = local.setup.azure.environment
  }
} 
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "bigip02-nsg-mgmt-int" {
    network_interface_id      = azurerm_network_interface.bigip02-mgmt-nic.id
    network_security_group_id = azurerm_network_security_group.mgmtnsg.id
}

resource "azurerm_network_interface_security_group_association" "bigip02-nsg-ext-int" {
    network_interface_id      = azurerm_network_interface.bigip02-ext-nic.id
    network_security_group_id = azurerm_network_security_group.extnsg.id
}

resource "azurerm_network_interface_security_group_association" "bigip02-nsg-int-int" {
    network_interface_id      = azurerm_network_interface.bigip02-int-nic.id
    network_security_group_id = azurerm_network_security_group.intnsg.id
}

# Setup Onboarding scripts
data "template_file" "bigip02_onboard" {
  template = file("${path.module}/onboard.tpl")

  vars = {
    admin_user     = local.setup.bigip.user_name
    admin_password = local.setup.bigip.user_password
    DO_URL         = local.setup.f5_atc.DO_URL
    AS3_URL        = local.setup.f5_atc.AS3_URL
    TS_URL         = local.setup.f5_atc.TS_URL
    FAST_URL       = local.setup.f5_atc.FAST_URL
    libs_dir       = local.setup.f5_atc.libs_dir
    onboard_log    = local.setup.f5_atc.onboard_log
  }
}

# Create BIG-IP VM
resource "azurerm_linux_virtual_machine" "bigip02" {
  name                            = "student${local.setup.azure.student_number}-bigip02"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.bigip02-mgmt-nic.id, azurerm_network_interface.bigip02-ext-nic.id, azurerm_network_interface.bigip02-int-nic.id]
  zone                            = 2
  size                            = local.setup.bigip.instance_type
  admin_username                  = local.setup.bigip.user_name
  admin_password                  = local.setup.bigip.user_password
  disable_password_authentication = false
  computer_name                   = "student${local.setup.azure.student_number}bigip02"
  custom_data                     = base64encode(data.template_file.bigip01_onboard.rendered)
  

  os_disk {
    name                 = "student${local.setup.azure.student_number}bigip02-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.setup.bigip.publisher
    offer     = local.setup.bigip.bigip_product
    sku       = local.setup.bigip.bigip_image_name
    version   = local.setup.bigip.bigip_version
  }

  plan {
    name      = local.setup.bigip.bigip_image_name
    publisher = local.setup.bigip.publisher
    product   = local.setup.bigip.bigip_product
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorage.primary_blob_endpoint
  }

  tags = {
    Name        = "student${local.setup.azure.student_number}-bigip02"
    environment = local.setup.azure.environment
  }
}

# Run Startup Script
resource "azurerm_virtual_machine_extension" "bigip02-run-startup-cmd" {
  name                 = "student${local.setup.azure.student_number}-bigip02-run-startup-cmd"
  virtual_machine_id   = azurerm_linux_virtual_machine.bigip02.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "bash /var/lib/waagent/CustomData; exit 0;"
    }
  SETTINGS

  tags = {
    Name        = "student${local.setup.azure.student_number}-bigip02-startup-cmd"
    environment = local.setup.azure.environment
  }
}

