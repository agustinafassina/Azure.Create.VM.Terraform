# Create vm with Terraform
In this repository, there is a Terraform script that creates the VMs.

## Requirenments
Azure account

## Variables in the .tfvars files
```
qa.tfvars
```

## Steps
1. Azure Login
```
az login
```
2. Selection of subscription

3. Terraform init and terraform workspace
```
terraform init
terraform workspace select qa
```

4. Terraform plan
```
terraform plan -var-file qa.tfvars
```

5. Terraform apply
```
terraform apply -var-file qa.tfvars
```
