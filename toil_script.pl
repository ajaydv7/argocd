#!/bin/perl

open (STDOUT, "| tee -ai log.txt");
bannerPrint("DOCKER INSTALLATION");
system("sudo yum install -y yum-utils device-mapper-persistent-data lvm2 vim");
system("sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo");
system("sudo yum update -y");
system("sudo yum install -y docker-ce docker-ce-cli containerd.io");

system("mkdir -p /etc/systemd/system/docker.service.d");
system("systemctl daemon-reload");

system("systemctl daemon-reload");
system("systemctl enable docker");
system("systemctl start docker");
system("systemctl status docker");
system("sudo docker run hello-world");
system("sudo docker images");

bannerPrint("MINIKUBE INSTALLATION");



sub bannerPrint{
	my $arg=shift;
	print "===========================================\n";
	print "===========================================\n";
	print "\t\t${arg}\n";
	print "===========================================\n";
	print "===========================================\n";
	
	
}	


system("curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.22.0/minikube-linux-amd64");
system("sudo chmod +x minikube");
system("sudo mv minikube /usr/bin/");
system("systemctl status firewalld");
system("systemctl stop firewalld");
system("systemctl disable firewalld");
system("yum install conntrack -y");

bannerPrint("INSTALL CRICTL");
system("curl -L -O https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz");
	system("tar xvf crictl-v1.0.0-beta.0-linux-amd64.tar.gz");
	system("mv crictl /usr/bin/crictl");
	

bannerPrint("CRI_DOCKERD");
my $VER=`$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g'`;
system("echo $VER");
system("wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz");
system("tar xvf cri-dockerd-${VER}.amd64.tgz");
system("sudo mv cri-dockerd/cri-dockerd /usr/local/bin/");
system("cri-dockerd --version");

bannerPrint("ENABLE CRI_DOCKERD SERVICE");
system("wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service");
system("wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket");

system("sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/");
system("sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service");

system("sudo systemctl daemon-reload");
system("sudo systemctl enable cri-docker.service");
system("sudo systemctl enable --now cri-docker.socket");
system("sudo systemctl status cri-docker.socket");

bannerPrint("STARTING MINIKUBE");
system("minikube start --vm-driver=none");
bannerPrint("MINIKUBE STATUS");
system("minikube status");

my $kubever = `curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`;
bannerPrint("INSTALL KUBECTL");
system("curl -LO https://storage.googleapis.com/kubernetes-release/release/${kubever}/bin/linux/amd64/kubectl");
system("chmod +x ./kubectl");
system("mv ./kubectl /usr/local/bin/kubectl");
system("kubectl help");

bannerPrint("NODE INFORMATION");
system("kubectl get node");

bannerPrint("INSTALL GIT");
system("yum install -y git");

bannerPrint("INSTALL HELM");
system("curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3");
system("chmod 700 get_helm.sh");
system("./get_helm.sh");

system("helm version");
close (STDOUT);
