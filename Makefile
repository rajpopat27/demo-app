GITHUB_USER=rajpopat27
.PHONY: all
all: kind
docker:
	@echo "Installing docker"
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh
	sudo usermod -aG docker ubuntu
kind:	
	@echo "Installing Kind"
	curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
	chmod +x ./kind
	sudo mv ./kind /usr/local/bin/kind
KindCluster:	
	@echo "Creating Kind Cluster"
	sudo kind create cluster --name=kind2 --config ./kindCluster.yaml
kubectl:
	sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl
fluxSetup:
	flux bootstrap github \
	--owner=$(GITHUB_USER) \
	--repository=fluxfleet-infra \
	--branch=main \
	--path=./clusters/ \
	--personal