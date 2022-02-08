#!/bin/bash


TIMEZONE=${TIMEZONE:-Asia/Singapore}

PROJECT_HOME=${PROJECT_HOME:-$HOME}
export PATH=${PATH}:${PROJECT_HOME}/bin

[[ ! -d $PROJECT_HOME/bin ]] && mkdir -p $PROJECT_HOME/bin

TIMEZONE=${TIMEZONE:-Asia/Singapore}
sudo ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"

function setup_common(){
    echo == Common tools

	OS_TOOLS=(\
		apt-transport-https \
        bat \
		bzip2 \
		ca-certificates \
		coreutils \
		curl \
		direnv \
		dnsutils \
		file \
		git \
		gnupg2 \
		gnupg-agent \
		hping3 \
		httpie \
		iperf \
		iputils-ping \
		iputils-tracepath \
		jq \
        lego \
		less \
		lsb-release \
		man \
		mosh \
		mtr \
		netcat \
		nmap \
		python3-pip \
		rclone \
		screen \
		shellcheck \
		software-properties-common \
		tcpdump \
		tmate \
		tmux \
		traceroute \
		unzip \
		vim \
		wamerican \
		wget \
		whois
		)
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install -y "${OS_TOOLS[@]}"

    if [[ "${ARCH}" == "amd64" ]]; then
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
        sudo add-apt-repository ppa:rmescandon/yq
        sudo apt update
        sudo apt install yq -y
    fi

}

function setup_profile (){
    echo == Profile
	curl -L https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/dotfiles-init.Linux.sh  | bash
}


function setup_k8s (){
    echo == K8s
	[[ -f /etc/apt/sources.list.d/kubernetes.list ]] ||
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -


	[[ -f /etc/apt/sources.list.d/docker.list ]] ||
        echo  "deb [arch=${ARCH}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list.d/docker.list
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	[[ -f /etc/apt/sources.list.d/helm-stable-debian.list ]] ||
        echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -a


	sudo apt-get update
	sudo apt-get install -qqy \
      docker-ce-cli \
      docker-compose \
	  kubectl \
	  helm

	# K14s kapp, ytt, kbld
    wget -O- https://carvel.dev/install.sh | K14SIO_INSTALL_BIN_DIR=$HOME/bin bash

    curl -sS https://webinstall.dev/k9s | bash

    (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
    )

	export PATH="${PROJECT_HOME}/bin:${PATH}:${HOME}/.krew/bin"
    kubectl krew install access-matrix cert-manager ctx konfig ns tail  || echo "[WARNING] Some plugins were not installed"

	helm repo add elastic https://helm.elastic.co
	helm repo add harbor https://helm.goharbor.io
	helm repo add wavefront https://wavefronthq.github.io/helm/
	helm repo add jetstack https://charts.jetstack.io
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add stable https://kubernetes-charts.storage.googleapis.com

	helm repo update

    curl -sSL  https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${ARCH}.tar.gz  | tar -C ${PROJECT_HOME}/bin -xvf - k9s
    [[ "${ARCH}" == "amd64" ]] && curl -sSL  https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.tar.gz | tar -C ${PROJECT_HOME}/bin -xz dive
}


function cloud_common (){
	echo == Cloud Common
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=${ARCH}] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform
}

function setup_aws (){
	cloud_common
	echo == AWS CLI
	[[ "${ARCH}" == "amd64 ]] && " curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    [[ "${ARCH}" == "arm64 ]] && " curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	./aws/install -i ${PROJECT_HOME}/bin/aws-cli -b ${PROJECT_HOME}/bin
	rm -rf awscliv2.zip ./aws

}

function setup_gcp(){
    # GCP SDK
    [[ -f /etc/apt/sources.list.d/google-cloud-sdk.list ]] ||
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update
    sudo apt-get install -qqy google-cloud-sdk
}

function setup_azure(){
    curl -sL https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs)
    [[ -f /etc/apt/sources.list.d/azure-cli.list ]] ||
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
        sudo tee /etc/apt/sources.list.d/azure-cli.list
    sudo apt-get update
    sudo apt-get install -qqy azure-cli
}

for comp in $*
do
	setup_$comp
done
