# Create VM with Terraform / Crear VM con Terraform
### English
This repository offers a Terraform configuration for deploying virtual machines in Azure, enabling automated and efficient cloud infrastructure management. Perfect for setting up scalable and reproducible environments.

#### Diagram 📋
<img src="diagram.png" alt="Diagram" width="400" height="450">

#### Requirements 📄
- Azure account
- Terraform >= 1.5
- Azure CLI (`az login`)

#### Setup 🛠️
1. Create `qa.tfvars` from the template and define your variables:
   ```
   cp qa-template.tfvars qa.tfvars
   # Edit qa.tfvars with your values
   ```

#### Steps 👣
1. **Azure Login**
   ```bash
   az login
   ```

2. **Select subscription** (if you have multiple)
   ```bash
   az account set --subscription "your-subscription-id"
   ```

3. **Initialize Terraform and select workspace**
   ```bash
   terraform init
   terraform workspace select qa
   ```

4. **Plan**
   ```bash
   terraform plan -var-file=qa.tfvars
   ```

5. **Apply**
   ```bash
   terraform apply -var-file=qa.tfvars
   ```

### Español
Este repositorio ofrece una configuracion de Terraform para desplegar maquinas virtuales en Azure, permitiendo la gestion automatizada y eficiente de infraestructura en la nube. Ideal para configurar entornos escalables y reproducibles.

#### Diagrama 📋

<img src="diagram.png" alt="Diagrama" width="400" height="450">

#### Requisitos 📄

- Cuenta de Azure
- Terraform >= 1.5
- Azure CLI (`az login`)

#### Configuracion 🛠️
1. Crear `qa.tfvars` a partir de la plantilla y define las variables:
   ```
   cp qa-template.tfvars qa.tfvars
   # Edita qa.tfvars con los valores
   ```

#### Pasos 👣
1. **Iniciar sesion en Azure**
   ```bash
   az login
   ```

2. **Seleccionar suscripcion** (si tienes varias)
   ```bash
   az account set --subscription "tu-id-de-suscripcion"
   ```

3. **Inicializar Terraform y seleccionar workspace**
   ```bash
   terraform init
   terraform workspace select qa
   ```

4. **Planificar**
   ```bash
   terraform plan -var-file=qa.tfvars
   ```

5. **Aplicar**
   ```bash
   terraform apply -var-file=qa.tfvars
   ```
