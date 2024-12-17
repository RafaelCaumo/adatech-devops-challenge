#!/bin/bash

set -e  # Interrompe o script em caso de erro
set -o pipefail  # Captura erros em pipes
trap "return 0" EXIT

# Função para verificar comandos
function check_command {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ Erro: '$1' não está instalado. Instale e tente novamente."
        return 1
    fi
}

# Valida dependências
check_command az
check_command terraform

echo "🔐 Realizando login no Azure CLI. Por favor, autentique-se."
az login >/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Falha ao realizar login no Azure CLI."
    return 1
fi

# Configurações do ambiente
WORKLOAD="tfstate"
ENVIRONMENT="dev"
REGION="brazilsouth"
RESOURCE_GROUP_NAME="rg-${WORKLOAD}-${ENVIRONMENT}-${REGION}"
STORAGE_ACCOUNT_NAME=""
CONTAINER_NAME="tfstate"
BACKEND_FILE="backend.tf"

echo "ℹ️  Assinatura atual configurada:"
SUBSCRIPTION_ID=$(az account show --query "id" -o tsv)
echo "   - ID: $SUBSCRIPTION_ID"

# Exporta a Subscription ID para o Terraform
export ARM_SUBSCRIPTION_ID="$SUBSCRIPTION_ID"
echo "✅ Variável ARM_SUBSCRIPTION_ID exportada para o Terraform."

# Função para criar o backend
function create_backend() {
    echo "🚀 Criando backend para armazenar arquivos de estado..."

    STORAGE_ACCOUNT_NAME="st${WORKLOAD}${ENVIRONMENT}$(shuf -i 1000-9999 -n 1)"
    az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION" --output none
    az storage account create --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$STORAGE_ACCOUNT_NAME" --sku Standard_LRS --encryption-services blob --output none
    sleep 10

    az storage container create --name "$CONTAINER_NAME" --account-name "$STORAGE_ACCOUNT_NAME" --output none
    update_backend_file
}

# Função para buscar recursos existentes
function fetch_existing_backend() {
    echo "🔍 Buscando recursos existentes..."
    STORAGE_ACCOUNT_NAME=$(az storage account list \
        --resource-group "$RESOURCE_GROUP_NAME" --query "[0].name" -o tsv)
    if [ -n "$STORAGE_ACCOUNT_NAME" ]; then
        echo "✅ Storage Account encontrado: $STORAGE_ACCOUNT_NAME"
        CONTAINER_EXISTS=$(az storage container exists \
            --name "$CONTAINER_NAME" --account-name "$STORAGE_ACCOUNT_NAME" --query "exists" -o tsv)
        if [ "$CONTAINER_EXISTS" != "true" ]; then
            echo "⚠️  Container '$CONTAINER_NAME' não encontrado. Criando..."
            az storage container create --name "$CONTAINER_NAME" --account-name "$STORAGE_ACCOUNT_NAME" --output none
        else
            echo "✅ Container '$CONTAINER_NAME' encontrado."
        fi
        update_backend_file
    else
        echo "⚠️  Nenhum Storage Account encontrado. Criando backend..."
        create_backend
    fi
}

# Função para atualizar o backend.tf
function update_backend_file() {
    echo "📝 Atualizando o arquivo '$BACKEND_FILE'..."
    cat <<EOF > "$BACKEND_FILE"
terraform {
  backend "azurerm" {
    resource_group_name  = "$RESOURCE_GROUP_NAME"
    storage_account_name = "$STORAGE_ACCOUNT_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "terraform.tfstate"
  }
}
EOF
    echo "✅ Arquivo '$BACKEND_FILE' atualizado com sucesso!"
}

# Provisionamento do Terraform
function terraform_provisioning() {
    echo "🚀 Executando Terraform..."
    terraform init
    terraform plan
    terraform apply -auto-approve
}

# Lógica principal
if [ "$(az group exists --name $RESOURCE_GROUP_NAME)" = "true" ]; then
    fetch_existing_backend
else
    create_backend
fi

terraform_provisioning