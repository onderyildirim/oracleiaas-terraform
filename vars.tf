variable "prefix" {
  description = "prefix to be used in resource names"
  default     = "ora"
}

variable "location" {
  description = "Azure region abbr"
  default     = "eastus"
}

variable "oracleVmSize" {
  description = "Oracle VM SKU"
  default     = "Standard_DS1_v2"
}

variable "controllerVmSize" {
  description = "Controller VM SKU"
  default     = "Standard_DS1_v2"
}

variable "sshKeyFile" {
  description = "Path to ssh key file to use for ssh login to VMs"
  default     = "~/.ssh/id_rsa.pub"
}

variable "configureVmScriptFile" {
  description = "Name of script file in the current dırectory used to configure vm"
  default     = "ora-vm-script.sh.sh"
}

locals{
  oraMntDir="/u02"
}

# locals{
#     resourceGroupName = "${var.prefix}-rg"
#     primaryOracleVMName="${var.prefix}-vm1"
#     secondaryOracleVMName="${var.prefix}-vm2"
#     vnetName= "${var.prefix}-vnet"
#     subnetName = "${var.prefix}-subnet"
#     avsetName = "${var.prefix}-avset"
# }

# variable "primaryOracleVMName" {
#   description = "name of primary server"
#   default     = "${var.prefix}-vm1"
# }

# variable "secondaryOracleVMName" {
#   description = "name of secondary server"
#   default     = "${var.prefix}-vm2"
# }

# variable "vnetName" {
#   description = "name of vnet"
#   default     = "${var.prefix}-vnet"
# }

# variable "subnetName" {
#   description = "name of subnet"
#   default     = "${var.prefix}-subnet"
# }

# variable "oracleMarketplaceImageUrn" { # run "az vm image list --offer Oracle-Database --all --publisher Oracle --output table" to get the latest version
#   description = "image urn"
#   default     = "Oracle:oracle-database-19-3:oracle-database-19-0904:19.3.1"
# }

variable "oracleVMAdminUser" {
  description = "name of admin user"
  default     = "azureuser"
}

variable "oracleVMAdminPassword" {
  description = "password for admin user"
  default     = "Password1234!"
}

