provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name  = "App-rg"
        storage_account_name = "tfstatekolloju"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}



resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "Australia East"
}

resource "azurerm_container_group" "tfcg_test" {
  name                      = "sampleapp"
  location                  = azurerm_resource_group.tf_test.location
  resource_group_name       = azurerm_resource_group.tf_test.name

  ip_address_type     = "public"
  dns_name_label      = "sampleapp"
  os_type             = "Linux"

  container {
      name            = "sampleapp2"
      image           = "kubesrinath/sampleapp:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }
}