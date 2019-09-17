##################################################################################
# VARIABLES
##################################################################################

variable "client_id" {
  type        = "string"
  description = "Client ID"
}

variable "client_secret" {
  type        = "string"
  description = "Client secret."
}

variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
  default     = "aks"
}

variable "resource_group_location" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "southeastasia"
}

variable "agent_pool_node_count" {
  default = 2
}

variable "agent_pool_vm_size" {
  default = "Standard_DS2_v2"
}

variable "agent_pool_vm_type" {
  default = "VirtualMachineScaleSets"
}

variable "agent_pool_os_disk_size_gb" {
  default = 30
}

variable "agent_pool_max_pods" {
  default = 30
}

variable "aks_name" {
  type        = "string"
  description = "Name of aks cluster."
  default     = "myaks"
}

variable "environment" {
  type        = "string"
  description = "dev, test or production."
  default     = "dev"
}

variable "creationSource" {
  type    = "string"
  default = "terraform"
}

variable "linux_admin_username" {
  type        = "string"
  description = "User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
  default     = "azureuser"
}
