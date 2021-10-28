#!/bin/bash

sudo apt-get update -qq
sudo apt-get update

# ___________________________
#
# PREREQUISITES
#
# ___________________________

swapoff -a

# PREREQUISITES
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
sudo apt-get update

# ___________________________
#
# DOWNLOAD AND INSTALL DOCKER
#
# ___________________________

sudo apt-get install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo apt-get update
sudo apt-get install -y apt-transport-https 
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# FIX DOCKER CGROUP DRIVER. MAKE SURE TO USES SYSTEMD
sudo mkdir /etc/systemd/system/docker.service.d
cat << EOF >> cgroupf_fix
ExecStart=/usr/bin/dockerd --exec-opt native.cgroupdriver=systemd
EOF

cat <<EOF >> cgroupf_fix_2
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

sudo mv cgroupf_fix_2 /etc/docker/daemon.json
sudo mv cgroupf_fix /etc/systemd/system/docker.service.d/override.conf

# ___________________________
#
# DOWNLOAD AND INSTALL KUBERNETES
#
# ___________________________

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo docker info | grep Cgroup

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml


# ___________________________
#
# DOWNLOAD AND INSTALL HELM
#
# ___________________________

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# ___________________________
#
# DOWNLOAD AND INSTALL TRAEFIK INGRESS CONTROLLER
#
# ___________________________

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik

HTTP_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services traefik)
HTTPS_PORT=$(kubectl get -o jsonpath="{.spec.ports[1].nodePort}" services traefik)

# ADD DASHBOARD
kubectl apply -f /tmp/deployments/dashboard.yaml



