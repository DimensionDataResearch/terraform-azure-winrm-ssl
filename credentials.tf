provider "azurerm" {
    subscription_id = "<your subscription>"

    # For details on how to obtain these values, see https://www.terraform.io/docs/providers/azurerm/index.html#creating-credentials
    client_id       = "<your client Id>"
    client_secret   = "<your secret>"
    tenant_id       = "<your azure AD tenant Id>"
}
