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

variable "aks_name" {
  type        = "string"
  description = "Name of aks cluster."
  default     = "myaks"
}

variable "aks_node_count" {
  default = 2
}

variable "acr_name" {
  type        = "string"
  description = "Name of azure container registry."
  default     = "melvinhub"
}

variable "environment" {
  type        = "string"
  description = "dev, test or production."
  default     = "dev"
}

variable "creationSource" {
  type        = "string"
  default     = "terraform"
}

variable "linux_admin_username" {
  type        = "string"
  description = "User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
  default     = "azureuser"
}
