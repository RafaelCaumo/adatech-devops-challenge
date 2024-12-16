# 🚀 Desafio DevOps Let's Code

Este repositório contém a solução para o **Desafio DevOps** proposto pela **Ada Tech**. O projeto visa demonstrar habilidades em **Infraestrutura como Código (IaC)**, **conteinerização**, **orquestração de aplicações** e **automação** no Azure.

---

## 📁 Estrutura do Repositório

```plaintext
adatech-devops-challenge/
│
├── backend/           # Código fonte do Backend
│   └── app/           # Aplicação backend em Java (Spring Boot)
│
├── frontend/          # Código fonte do Frontend
│   └── app/           # Aplicação frontend
│
├── infra/             # Infraestrutura como Código (IaC)
│   ├── aks.tf         # Configuração do Azure Kubernetes Service (AKS)
│   ├── backend.tf     # Configuração do backend do Terraform
│   ├── database.tf    # Provisionamento do banco de dados MySQL
│   ├── helm.tf        # Deploy das aplicações com Helm no AKS
│   ├── main.tf        # Configuração principal do Terraform
│   ├── monitoring.tf  # Configuração do monitoramento (Azure Monitor Agent)
│   ├── network.tf     # Configuração de rede
│   ├── output.tf      # Outputs do Terraform
│   ├── provider.tf    # Configuração do Provider Azure
│   ├── security.tf    # Configuração de segurança
│   └── startup.sh     # Script de auto-provisionamento
│
├── .gitignore         # Arquivos ignorados pelo Git
└── README.md          # Documentação do projeto

🛠️ Tecnologias Utilizadas

Tecnologia	Descrição
Azure Cloud	Plataforma de nuvem para hospedar a infraestrutura
Terraform	Provisionamento de recursos no Azure
Kubernetes (AKS)	Orquestração de containers gerenciada no Azure
Helm	Gerenciamento e deploy de pacotes no Kubernetes
Docker	Construção e gerenciamento de containers
Azure Monitor	Monitoramento nativo no Azure
Bash Scripts	Automação para provisionamento e deploy

⚙️ Configuração do Ambiente

1. Pré-requisitos

Instale as seguintes ferramentas no seu ambiente local:
	•	Azure CLI
	•	Terraform
	•	Helm
	•	Docker
	•	Conta ativa no Microsoft Azure.

🚀 Provisionamento da Infraestrutura
Provisionamento Automático

Execute o script de inicialização:

source ./startup.sh

Provisionamento Manual

1. Login no Azure

Faça login na sua conta Azure:

az login

2. Definir Variáveis

Configure as variáveis necessárias:

export SUBSCRIPTION_ID=<seu_subscription_id>
export RESOURCE_GROUP_NAME="rg-tfstate-prod"
export STORAGE_ACCOUNT_NAME="sttfstate$(shuf -i 1000-9999 -n 1)"

3. Inicialização do Terraform

Acesse a pasta infra/ e inicialize o Terraform:

cd infra/
terraform init

4. Planejamento e Deploy

Planeje e aplique as configurações:

terraform plan
terraform apply -auto-approve

Provisionamento Automático

Execute o script de inicialização:

source ./startup.sh

🌐 Acesso às Aplicações

Os endpoints das aplicações serão exibidos nos outputs do Terraform após o provisionamento.

Exemplo de Saída:

Outputs:

frontend_address = "http://ada.development.<unique_id>.brazilsouth.aksapp.io"

🔍 Monitoramento

O Azure Monitor Agent está configurado para enviar logs e métricas diretamente para o Azure Monitor.
	1.	Acesse o Azure Portal.
	2.	Navegue até Monitor > Log Analytics.
	3.	Consulte as métricas e logs capturados pelo agente.

📜 Licença

Este projeto está licenciado sob a Licença MIT.

📞 Contato
	•	Autor: Rafael Caumo
	•	LinkedIn: https://www.linkedin.com/in/rafaelcaumo/

🔗 Referências
	•	Desafio DevOps Let’s Code