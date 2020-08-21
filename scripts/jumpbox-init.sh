#!/bin/bash


TIMEZONE=${TIMEZONE:-Asia/Singapore}

PROJECT_HOME=${PROJECT_HOME:-$HOME}
export PATH=${PATH}:${PROJECT_HOME}/bin

[[ ! -d $PROJECT_HOME/bin ]] && mkdir -p $PROJECT_HOME/bin

TIMEZONE=${TIMEZONE:-Asia/Singapore}
sudo ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
function setup_common(){
    echo == Common tools

	OS_TOOLS=(\
		apt-transport-https \
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
		less \
		lsb-release \
		man \
		mosh \
		mtr \
		netcat \
		nmap \
		python2.7-minimal \
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
		whois \
		nginx     
		)
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install -y "${OS_TOOLS[@]}"
	sudo curl  -sSL https://bootstrap.pypa.io/get-pip.py | python2.7

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --64 --all --completion --update-rc --key-bindings
    
	wget -q  https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-v0.15.4-x86_64-unknown-linux-gnu.tar.gz -O- | tar -C /tmp -xz bat-v0.15.4-x86_64-unknown-linux-gnu/bat
	mv /tmp/bat-v0.15.4-x86_64-unknown-linux-gnu/bat ${PROJ_DIR}/bin/bat
	chmod a+x  ${PROJ_DIR}/bin/bat
	rm -rf /tmp/bat-v0.13.0-x86_64-unknown-linux-gnu
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
        echo  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list.d/docker.list
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	[[ -f /etc/apt/sources.list.d/helm-stable-debian.list ]] || 
        echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -a


	sudo apt-get update
	sudo apt-get install -qqy \
	  docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-compose \
	  kubectl \
	  helm 
	

	# K14s kapp, ytt, kbld 
	curl -L https://k14s.io/install.sh | K14SIO_INSTALL_BIN_DIR=${PROJ_DIR}/bin bash




	(
	  set -x; cd "$(mktemp -d)" &&
	  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" &&
	  tar zxvf krew.tar.gz &&
	  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
	  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
	  "$KREW" update
	)

	export PATH="${PROJECT_HOME}/bin:${PATH}:${HOME}/.krew/bin"
	echo export PATH="\${PROJ_DIR}/bin:\${PATH}:\${HOME}/.krew/bin" >> ~/.bashrc
	echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
	kubectl krew install ctx
	kubectl krew install ns
	kubectl krew install tail
	kubectl krew install access-matix


	sudo usermod -aG docker $USER


	helm repo add elastic https://helm.elastic.co
	helm repo add harbor https://helm.goharbor.io
	helm repo add wavefront https://wavefronthq.github.io/helm/
	helm repo add jetstack https://charts.jetstack.io
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add stable https://kubernetes-charts.storage.googleapis.com

	helm repo update

	curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-linux-amd64
	chmod +x ./kind
	mv ./kind ${PROJ_DIR}/bin/kind

    curl -sSL https://github.com/derailed/k9s/releases/download/v0.21.7/k9s_Linux_x86_64.tar.gz | tar -C ${PROJ_DIR}/bin -xz k9s
    curl -sSL  https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.tar.gz | tar -C ${PROJ_DIR}/bin -xz dive
}


function cloud_common (){
	echo == Cloud Common
	wget -q https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip -O /tmp/terraform.zip
	gunzip -S .zip /tmp/terraform.zip
	mv /tmp/terraform ${PROJ_DIR}/bin/terraform
	chmod a+x ${PROJ_DIR}/bin/terraform
}

function setup_aws (){
	cloud_common
	echo == AWS CLI 
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	./aws/install
	rm -rf awscliv2.zip ./aws
	
}

function setup_tkgi(){
    
    echo == TKGI
    wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
    [[ -f /etc/apt/sources.list.d/cloudfoundry-cli.list ]] || 
        echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

    # Bosh
    URL=https://github.com/cloudfoundry/bosh-cli/releases/download/v6.3.1/bosh-cli-6.3.1-linux-amd64
    wget -q ${URL} -O ${PROJ_DIR}/bin/bosh
    chmod a+x ${PROJ_DIR}/bin/bosh

    # BBR
    URL=https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v1.7.2/bbr-1.7.2-linux-amd64
    wget -q ${URL} -O ${PROJ_DIR}/bin/bbr
    chmod a+x ${PROJ_DIR}/bin/bbr

    # Credhub
    URL=https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.8.0/credhub-linux-2.8.0.tgz
    wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -xz  ./credhub
    chmod a+x ${PROJ_DIR}/bin/credhub

    # Fly
    URL=https://github.com/concourse/concourse/releases/download/v6.3.1/fly-6.3.1-linux-amd64.tgz
    wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -zx fly
    chmod a+x ${PROJ_DIR}/bin/fly
    
    # OM
    URL=https://github.com/pivotal-cf/om/releases/download/6.1.2/om-linux-6.1.2.tar.gz
    wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -zx om
    chmod a+x ${PROJ_DIR}/bin/om

    # PIVNET
    URL=https://github.com/pivotal-cf/pivnet-cli/releases/download/v1.0.4/pivnet-linux-amd64-1.0.4
    wget -q ${URL} -O ${PROJ_DIR}/bin/pivnet
    chmod a+x ${PROJ_DIR}/bin/pivnet
    
    # UAA
    URL=https://github.com/cloudfoundry-incubator/uaa-cli/releases/download/0.10.0/uaa-linux-amd64-0.10.0
    wget -q ${URL} -O ${PROJ_DIR}/bin/uaa
    chmod a+x ${PROJ_DIR}/bin/uaa
    
    #PKS
    VERSION=1.8.1
    om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p pivotal-container-service --pivnet-file-glob='pks-linux-amd64-*'
    mv /tmp/pks-linux-amd64-* ${PROJ_DIR}/bin/pks
    chmod a+x ${PROJ_DIR}/bin/pks
}

function setup_vsphere (){
	
	echo == Vsphere
	wget -q https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_linux_amd64.gz | gunzip -O- > ${PROJ_DIR}/bin/govc
	chmod a+x $PROJ_DIR/bin/govc
}

function setup_gcp(){
    # GCP SDK
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
}

function setup_azure(){
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | 
        gpg --dearmor | 
        sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs) 
    [[ -f /etc/apt/sources.list.d/azure-cli.list ]] || 
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | 
        sudo tee /etc/apt/sources.list.d/azure-cli.list
}

function setup_tanzu(){
	echo == Tanzu = TMC
	curl -sSL https://vmware.bintray.com/tmc/0.1.0-d11404fb/linux/x64/tmc -o $PROJECT_HOME/bin/tmc
	chmod a+x $PROJECT_HOME/bin/tmc
}

for comp in $*
do 
	setup_$comp
done
