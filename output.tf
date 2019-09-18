##################################################################################
# OUTPUTS
##################################################################################

output "aks" {
  value = {
    id = azurerm_kubernetes_cluster.aks.id
    fqdn = azurerm_kubernetes_cluster.aks.fqdn
    node_resource_group = azurerm_kubernetes_cluster.aks.node_resource_group
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "config" {
  value = <<CONFIGURE

Run the following commands to configure kubernetes clients:

$ terraform output kube_config > ~/.kube/aksconfig
$ export KUBECONFIG=~/.kube/aksconfig

Test configuration using kubectl

$kubectl get nodes

CONFIGURE
}
