variable "machine_name" {
	default = "af-tf-vm1"
}

resource "azurerm_virtual_machine" "test" {
	 name = "${var.machine_name}"
	 location = "${var.location}"
	 resource_group_name = "${azurerm_resource_group.test.name}"
	 network_interface_ids = ["${azurerm_network_interface.test.id}"]
	 vm_size = "Basic_A1"

	 storage_image_reference {
		 publisher = "MicrosoftWindowsServer"
		 offer = "WindowsServer"
		 sku = "2012-R2-Datacenter"
		 version = "latest"
	 }

	 storage_os_disk {
		 name = "${var.machine_name}-osdisk1"
		 vhd_uri = "${azurerm_storage_account.test.primary_blob_endpoint}${azurerm_storage_container.test.name}/${var.machine_name}-osdisk1.vhd"
		 caching = "ReadWrite"
		 create_option = "FromImage"
	 }

	 os_profile {
		 computer_name = "${var.machine_name}"
		 admin_username = "tintoy"
		 admin_password = "asswordPolicy!"
	 }

	 os_profile_windows_config {
		 winrm {
			 protocol = "http"
		 }
		 provision_vm_agent = true
	 }

	 tags {
		 environment = "${var.environment_name}"
	 }
}

resource "null_resource" "enable-winrm" {
	provisioner "local-exec" {
		command = "azure vm extension set ${azurerm_resource_group.test.name} ${azurerm_virtual_machine.test.name} EnableWinRM -p Microsoft.Compute -n CustomScriptExtension -o 1.8 --public-config-path enable-winrm.json"
	}
}
