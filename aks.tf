resource "tls_private_key" "key" {
  algorithm   = "RSA"
  ecdsa_curve = "P224"
  rsa_bits    = "2048"
}

resource "azurerm_kubernetes_cluster" "main" {
  name       = "${var.aks_name}-k8s"
  location   = var.rg_location
  dns_prefix = "${var.aks_name}-dns"

  resource_group_name = var.rg_name

  linux_profile {
    admin_username = var.linux_admin_username

    ssh_key {
      key_data = "${trimspace(tls_private_key.key.public_key_openssh)}"
    }
  }

  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  agent_pool_profile {
    name            = "default"
    count           = var.agent_pool_node_count
    vm_size         = var.agent_pool_vm_size
    os_type         = "Linux"
    os_disk_size_gb = var.agent_pool_os_disk_size_gb
    vnet_subnet_id  = var.agent_pool_subnet_id 
    type            = var.agent_pool_vm_type
    max_pods        = var.agent_pool_max_pods
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.100.0.0/16"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = {
    creationSource = var.creationSource
    env            = var.environment
  }
}
