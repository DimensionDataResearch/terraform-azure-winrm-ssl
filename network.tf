resource "azurerm_virtual_network" "test" {
	name				= "test"
	address_space		 = ["10.0.0.0/16"]
	location			= "${var.location}"
	resource_group_name = "${azurerm_resource_group.test.name}"

	tags {
		 environment = "${var.environment_name}"
	 }
}

resource "azurerm_subnet" "test" {
	name				 = "test"
	resource_group_name	= "${azurerm_resource_group.test.name}"
	virtual_network_name = "${azurerm_virtual_network.test.name}"
	address_prefix		 = "10.0.2.0/24"
}

resource "azurerm_network_interface" "test" {
	name				= "test"
	location			= "${var.location}"
	resource_group_name = "${azurerm_resource_group.test.name}"
	ip_configuration {
		name                          = "testconfiguration1"
		subnet_id                     = "${azurerm_subnet.test.id}"
		private_ip_address_allocation = "dynamic"
		public_ip_address_id          = "${azurerm_public_ip.test.id}"
	}

	network_security_group_id = "${azurerm_network_security_group.test.id}"

	tags {
		 environment = "${var.environment_name}"
	 }
}

resource "azurerm_public_ip" "test" {
	name						 = "test"
	location					 = "${var.location}"
	resource_group_name			 = "${azurerm_resource_group.test.name}"
	public_ip_address_allocation = "static"
	domain_name_label            = "${var.machine_name}"

	tags {
		 environment = "${var.environment_name}"
	 }
}

resource "azurerm_network_security_group" "test" {
	name = "acceptanceTestSecurityGroup1"
	location = "West US"
	resource_group_name = "${azurerm_resource_group.test.name}"

	security_rule {
		name = "allow-rdp"
		priority = 101
		direction = "Inbound"
		access = "Allow"
		protocol = "Tcp"
		source_port_range = "*"
		destination_port_range = "3389"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}

	security_rule {
		name = "allow-winrm"
		priority = 100
		direction = "Inbound"
		access = "Allow"
		protocol = "Tcp"
		source_port_range = "*"
		destination_port_range = "5985-5986"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}

	tags {
		 environment = "${var.environment_name}"
	 }
}
