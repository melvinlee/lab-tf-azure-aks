# Iac (Infrastructure as Code)

This repository contain terraform template to provision:

- Azure Kubernetes Service (AKS) 

## Required Tooling

- Terraform >= 0.12
- Azure CLI >= 2.0

## Pre-requisites

Create a service principal for AKS

```sh
az ad sp create-for-rbac -n "aks-sp" --skip-assignment
```

Update varaibles.tfvars file and add your service principal clientid and clientsecret as variables. Examples:

```sh
client_id = "2f61810e-7f8d-49fd-8c0e-c4ffake51f9f"
client_secret = "57f8b670-012d-42b2-a0f8-c3fakee239ad"
```

## Provisioning

Run `terraform init` then `terraform plan` to see what will be created, finally if it looks good run `terraform apply`

```sh
terraform init
terraform plan -var-file=variables.tfvars -out=aks.tfplan
terraform apply aks.tfplan
```

## Kubectl

Run the following commands to configure kubernetes clients:

```sh
terraform output kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
```

Test configuration using kubectl

```sh
kubectl get nodes
```

## Cleanup

You can cleanup the Terraform-managed infrastructure.

```sh
terraform destroy -var-file=variables.tfvars -force
```