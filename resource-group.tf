variable "location" {
	default = "West US"
}
variable "environment_name" {
	default = "Terraform"
}

resource "azurerm_resource_group" "test" {
	name = "acctestrg"
	location = "${var.location}"
}
