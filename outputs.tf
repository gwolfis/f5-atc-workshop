# Azure environment
output "azure_resource_group" { value = "${local.setup.azure.resource_group}"}

#BIG-IP Management IP addres

output "bigip_1_mgmt_privip" { value = "${azurerm_network_interface.bigip01-mgmt-nic.private_ip_address}" }
output "bigip_1_mgmt_pubip"  { value = "${azurerm_public_ip.bigip01mgmtpip.ip_address}" }

output "bigip_2_mgmt_privip" { value = "${azurerm_network_interface.bigip02-mgmt-nic.private_ip_address}" }
output "bigip_2_mgmt_pubip"  { value = "${azurerm_public_ip.bigip02mgmtpip.ip_address}" }

# BIG-IP external IP Addresses
output "bigip_1_ext_selfip_privip" { value = "${azurerm_network_interface.bigip01-ext-nic.private_ip_address}" }
output "bigip_1_ext_selfip_pubip"  { value = "${azurerm_public_ip.bigip01selfextpip.ip_address}" }

output "bigip_2_ext_selfip_privip" { value = "${azurerm_network_interface.bigip02-ext-nic.private_ip_address}" }
output "bigip_2_ext_selfip_pubip"  { value = "${azurerm_public_ip.bigip02selfextpip.ip_address}" }

output "bigip_ext_pub_vippip1" { value = "${azurerm_public_ip.bigip01-pubvippip.ip_address}" }
output "bigip_ext_priv_vippip1" { value = "${local.setup.bigip.bigip_vip01}" }

output "bigip_ext_pub_vippip2"  { value = "${azurerm_public_ip.bigip02-pubvippip.ip_address}" }
output "bigip_ext_priv_vippip2" { value = "${local.setup.bigip.bigip_vip02}" }

# BIG-IP internal IP Addresses
output "bigip_1_int_selfip_privip" { value = "${azurerm_network_interface.bigip01-int-nic.private_ip_address}" }

output "bigip_2_int_selfip_privip" { value = "${azurerm_network_interface.bigip02-int-nic.private_ip_address}" }

# Web Server internal IP Addresses
output "web_1_int_selfip_privip" { value = "${azurerm_network_interface.web01-nic.private_ip_address}" }
output "web_2_int_selfip_privip" { value = "${azurerm_network_interface.web02-nic.private_ip_address}" }

# DVWA web frontend
output "dvwa_int_selfip_privip" { value = "${azurerm_network_interface.dvwa-nic.private_ip_address}"}

#
# Write output to file
#
data "template_file" "postman_environment" {
  template = file ("${path.module}/postman_environment.json.tpl")
  vars = {
    resource_group            = local.setup.azure.resource_group
    bigip_1_mgmt_privip       = azurerm_network_interface.bigip01-mgmt-nic.private_ip_address
    bigip_1_mgmt_pubip        = azurerm_public_ip.bigip01mgmtpip.ip_address
    bigip_2_mgmt_privip       = azurerm_network_interface.bigip02-mgmt-nic.private_ip_address
    bigip_2_mgmt_pubip        = azurerm_public_ip.bigip02mgmtpip.ip_address
    bigip_1_ext_selfip_privip = azurerm_network_interface.bigip01-ext-nic.private_ip_address
    bigip_1_ext_selfip_pubip  = azurerm_public_ip.bigip01selfextpip.ip_address
    bigip_2_ext_selfip_privip = azurerm_network_interface.bigip02-ext-nic.private_ip_address
    bigip_2_ext_selfip_pubip  = azurerm_public_ip.bigip02selfextpip.ip_address
    bigip_ext_pub_vippip1     = azurerm_public_ip.bigip01-pubvippip.ip_address
    bigip_ext_priv_vippip1    = local.setup.bigip.bigip_vip01
    bigip_ext_pub_vippip2     = azurerm_public_ip.bigip02-pubvippip.ip_address
    bigip_ext_priv_vippip2    = local.setup.bigip.bigip_vip02
    bigip_1_int_selfip_privip = azurerm_network_interface.bigip01-int-nic.private_ip_address
    bigip_2_int_selfip_privip = azurerm_network_interface.bigip02-int-nic.private_ip_address
    web_1_int_selfip_privip   = azurerm_network_interface.web01-nic.private_ip_address
    web_2_int_selfip_privip   = azurerm_network_interface.web02-nic.private_ip_address
    dvwa_int_selfip_privip    = azurerm_network_interface.dvwa-nic.private_ip_address
    subscription_id           = local.tmp.subscription_id
    client_id                 = local.tmp.client_id
    client_secret             = local.tmp.client_secret
    tenant_id                 = local.tmp.tenant_id
  }
}
resource "local_file" "postman_environment"{
  content = data.template_file.postman_environment.rendered
  filename = local.setup.postman.json_file
}