# Create vm with Terraform 💻
This repository offers a Terraform script for deploying virtual machines in Azure, enabling automated and efficient cloud infrastructure management. Perfect for setting up scalable and reproducible environments.

### Diagram
<img src="diagram.png" alt="Diagram" width="400" height="450">

### Requirements📝
- Azure account
- Create qa.tfvars file
- Define variables in qa.tfvars

## Steps 👣
1. Azure Login
```
az login
```
2. Selection of subscription

Since azurerm 4.x the subscription must be set explicitly: either `subscription_id` in qa.tfvars or the `ARM_SUBSCRIPTION_ID` environment variable.
```
az account set --subscription <subscription-id>
```
3. Terraform init and terraform workspace
```
terraform init
terraform workspace select -or-create qa
```

4. Terraform plan
```
terraform plan -var-file qa.tfvars
```

5. Terraform apply
```
terraform apply -var-file qa.tfvars
```
