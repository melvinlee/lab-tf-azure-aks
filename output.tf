##################################################################################
# OUTPUTS
##################################################################################

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.main.kube_config_raw}"
  sensitive   = true
}

output "aks_dashboard" {
  value = "az aks browse --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.main.name}"
}

output "config" {
  value = <<CONFIGURE

Run the following commands to configure kubernetes clients:

$ terraform output kube_config > ~/.kube/aksconfig
$ export KUBECONFIG=~/.kube/aksconfig

Test configuration using kubectl

$kubectl get nodes

Launch Dashboard
$ terraform output dashboard
CONFIGURE
}
