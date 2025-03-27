# Variables
APP_NAME=my-go-app
DOCKER_IMAGE=$(APP_NAME)
K8S_DEPLOYMENT=k8s/deployment.yml
TERRAFORM_DIR=terraform

# 🐳 Docker Commands
build:
	@echo "🚀 Building Docker Image..."
	docker build -t $(DOCKER_IMAGE) ./app

run: build
	@echo "🏃 Running Docker Container..."
	docker run --rm -p 8080:8080 $(DOCKER_IMAGE)

clean:
	@echo "🧹 Removing Docker Container and Image..."
	docker rm -f $(APP_NAME) || true
	docker rmi -f $(DOCKER_IMAGE) || true

# ☸️ Kubernetes Commands (Using Minikube)
k8s-start:
	@echo "🚀 Starting Minikube..."
	minikube start

k8s-deploy: k8s-start build
	@echo "📦 Deploying to Kubernetes..."
	eval $$(minikube docker-env) && docker build -t $(DOCKER_IMAGE) ./app
	kubectl apply -f $(K8S_DEPLOYMENT)

k8s-port-forward:
	@echo "🔄 Port-forwarding Kubernetes service..."
	kubectl port-forward svc/go-app-service 8080:8080

k8s-clean:
	@echo "🗑️ Deleting Kubernetes deployment..."
	kubectl delete -f $(K8S_DEPLOYMENT)
	minikube stop

# 🌍 Terraform Commands
tf-init:
	@echo "🛠️ Initializing Terraform..."
	cd $(TERRAFORM_DIR) && terraform init

tf-apply: tf-init
	@echo "🚀 Applying Terraform Configuration..."
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

tf-destroy:
	@echo "💀 Destroying Terraform Infrastructure..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

# 🔄 Full Automation
all: clean build run

deploy: clean build k8s-deploy k8s-port-forward

destroy: clean k8s-clean tf-destroy

.PHONY: build run clean k8s-start k8s-deploy k8s-port-forward k8s-clean tf-init tf-apply tf-destroy all deploy destroy
