Docker and minikube, Argo CD installation steps and login to argocd

Open terminal and execute below commands:



sudo su -

cd /home/user1/Desktop/

sudo yum install -y socat conntrack

perl toil_script.pl

 
 
for verifying the status of installation:
----------------------------------------------
 
systemctl status docker
minikube status
kubectl get node

Kubectl create namespace argocd 
 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
 
Kubectl get pods -n argocd
 
kubectl get svc -n argocd
 
kubectl edit svc argocd-server -n argocd 
 
minikube service argocd-server -n argocd 
 
kubectl get secret -n argocd
 
kubectl edit secret argocd-initial-admin-secret -n argocd
 
echo UDVUczlis#I0Qmdxc2lsWA== | base64 –decode
 
