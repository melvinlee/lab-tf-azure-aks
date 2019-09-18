##################################################################################
# VARIABLES
##################################################################################

variable "client_id" {
  type        = "string"
  description = "(Required) The Client ID for the Service Principal."
}

variable "client_secret" {
  type        = "string"
  description = "(Required) The Client Secret for the Service Principal."
}

variable "rg_name" {
  type        = "string"
  description = "(Required) Name of the azure resource group."
}

variable "rg_location" {
  type        = "string"
  description = "(Required) Location of the azure resource group."
}

variable "aks_name" {
  type        = "string"
  description = "The name of the Managed Kubernetes Cluster to create."
  default     = "myaks"
}

variable "agent_pool_subnet_id" {
  description = "(Required) The ID of the Subnet where the Agents in the Pool should be provisioned."
}

variable "agent_pools" {
  description = "list for agent_pools"
  default = [
    # "name", "count", "vm_size", "os_type", "os_disk_size_gb", "type", "max_pods"
    ["default", "1", "Standard_DS2_v2", "Linux", "50", "VirtualMachineScaleSets", "30"]
  ]
}

variable "linux_admin_username" {
  type        = "string"
  description = "User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
  default     = "azureuser"
}

variable "kubernetes_version" {
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster"
  default     = null
}

variable "tags" {
  description = "map of tags for the deployment"
  default = {
    environment    = "DEV"
    creationSource = "terraform"
  }
}

variable "enabled_oms_agent" {
  description = "(Required) Is the OMS Agent Enabled?"
  default     = false
}

variable "log_analytics_workspace" {
  description = "(Required) The ID of the Log Analytics Workspace which the OMS Agent should send data to."
}

variable "node_resource_group" {
  description = "(Optional) The name of the Resource Group where the the Kubernetes Nodes should exist."
  default     = null
}
