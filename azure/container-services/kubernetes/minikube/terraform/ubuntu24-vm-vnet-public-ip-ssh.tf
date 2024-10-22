## https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli
## 
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.app_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.global_tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${local.app_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-${local.app_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = local.global_tags
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.app_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-${local.app_name}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = local.global_tags
}

## 
resource "azurerm_linux_virtual_machine" "vm" {
  name                = local.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = local.vm_size
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/id_rsa_${local.app_name}.pub")  
    ## file("~/.ssh/id_rsa_${local.app_name}.pub")
  }

  os_disk {
    name                 = "ubuntu24-OsDisk-${local.app_name}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = local.vm_source_image.publisher
    offer     = local.vm_source_image.offer
    sku       = local.vm_source_image.sku
    version   = local.vm_source_image.version
  }

  computer_name  = local.vm_name
  disable_password_authentication = true

  #boot_diagnostics {
  #  storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  #}

  tags = local.global_tags

  depends_on = [local_file.public_key]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${local.app_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.global_tags
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/id_rsa_${local.app_name}"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/id_rsa_${local.app_name}.pub"
}

output "vm_public_ip" {
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
  description = "The public IP address of the VM"
  depends_on  = [azurerm_linux_virtual_machine.vm]
}

output "vm_user_name" {
  value = "adminuser"
}

output "public_key_file" {
  value = "${path.module}/id_rsa_${local.app_name}.pub"
}

output "private_key_file" {
  value = "${path.module}/id_rsa_${local.app_name}"
}