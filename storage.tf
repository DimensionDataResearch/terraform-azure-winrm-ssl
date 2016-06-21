variable "storage_account_name" {
	default = "ddaftftest1"
}

resource "azurerm_storage_account" "test" {
	 name = "${var.storage_account_name}"
	 resource_group_name = "${azurerm_resource_group.test.name}"
	 location = "${var.location}"
	 account_type = "Standard_LRS"

	 tags {
		 environment = "${var.environment_name}"
	 }
}

resource "azurerm_storage_container" "test" {
	 name = "vhds"
	 resource_group_name = "${azurerm_resource_group.test.name}"
	 storage_account_name = "${azurerm_storage_account.test.name}"
	 container_access_type = "private"
}
