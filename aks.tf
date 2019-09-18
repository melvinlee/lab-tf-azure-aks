resource "tls_private_key" "key" {
  algorithm   = "RSA"
  ecdsa_curve = "P224"
  rsa_bits    = "2048"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.aks_name}-aks"
  dns_prefix          = var.aks_name
  resource_group_name = var.rg_name
  location            = var.rg_location

  linux_profile {
    admin_username = var.linux_admin_username

    ssh_key {
      key_data = "${trimspace(tls_private_key.key.public_key_openssh)}"
    }
  }

  kubernetes_version = "${var.kubernetes_version != "" ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version}"

  dynamic "agent_pool_profile" {
    for_each = var.agent_pools
    content {
      name            = agent_pool_profile.value[0]
      count           = agent_pool_profile.value[1]
      vm_size         = agent_pool_profile.value[2]
      os_type         = agent_pool_profile.value[3]
      os_disk_size_gb = agent_pool_profile.value[4]
      vnet_subnet_id  = var.agent_pool_subnet_id
      type            = agent_pool_profile.value[5]
      max_pods        = agent_pool_profile.value[6]
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = var.enabled_oms_agent
      log_analytics_workspace_id = var.log_analytics_workspace
    }

    http_application_routing {
      enabled = var.enable_http_application_routing
    }
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

  node_resource_group = var.node_resource_group

  tags = var.tags
}
