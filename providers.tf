terraform {
  required_version = ">=1.5.2"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.66"
    }
  }
}


# Create SPN using steps from https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
# $> export MSYS_NO_PATHCONV=1 #only if using git bash
# $> az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>

# az ad sp create-for-rbac --name terraform_svc_principal --role Contributor --scopes /subscriptions/86a84b75-279e-4889-bf86-4ba99c562047
# Creating 'Contributor' role assignment under scope '/subscriptions/86a84b75-279e-4889-bf86-4ba99c562047'
# The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
# {
#   "appId": "0b4ae6f0-f266-40de-afa2-2771395487e3",
#   "displayName": "terraform_svc_principal",
#   "password": "n~o8Q~QuFVZnl5FRXP7r3gqvnLZy9HK2NuNHjad3",
#   "tenant": "16b3c013-d300-468d-ac64-7eda0820b6d3"
# }

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
  subscription_id   = "86a84b75-279e-4889-bf86-4ba99c562047"
  tenant_id         = "16b3c013-d300-468d-ac64-7eda0820b6d3"
  client_id         = "0b4ae6f0-f266-40de-afa2-2771395487e3"
  client_secret     = "n~o8Q~QuFVZnl5FRXP7r3gqvnLZy9HK2NuNHjad3"
}


# NetApp resource provider registration:
# You can manually register using following command
#       az provider register --namespace Microsoft.NetApp --wait
# or use terraform resource provider registration below
# resource "azurerm_resource_provider_registration" "anfProviderRegistration" {
#   name = "Microsoft.NetApp"
# }