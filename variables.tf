##################################################################################
# VARIABLES
##################################################################################

variable "client_id" {
  type        = "string"
  description = "(Required) Client ID"
}

variable "client_secret" {
  type        = "string"
  description = "(Required) Client secret."
}

variable "rg_name" {
  description = "(Required) Name of the azure resource group."
}

variable "rg_location" {
  description = "(Required) Location of the azure resource group."
}

variable "agent_pools" {
  description = "list for agent_pools"
  default = [
    # "name", "count", "vm_size", "os_type", "os_disk_size_gb", "type", "max_pods"
    ["default", "1", "Standard_DS2_v2", "Linux", "50", "VirtualMachineScaleSets","30"]
  ]
}

variable "aks_name" {
  type        = "string"
  description = "Name of aks cluster."
  default     = "myaks"
}

variable "linux_admin_username" {
  type        = "string"
  description = "User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
  default     = "azureuser"
}

variable "tags" {
  description = "map of tags for the deployment"
  default = {
    environment     = "DEV"
    creationSource  = "terraform"
  }
}
