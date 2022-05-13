#!/bin/bash
echo "Instaling Docker, Kubernetes and deploy the relevant Dashboards"
echo "Performing system update"
apt-get update -qq
apt-get update

# ___________________________
#
# PREREQUISITES
#
# ___________________________

echo "Deactivating swap memory"
swapoff -a

# PREREQUISITES
echo "Fixing networking parameters"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

echo "Fixing kernel parameters"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system
apt-get update
# ___________________________
#
# DOWNLOAD AND INSTALL DOCKER
#
# ___________________________
echo "Downloading and installing Docker"
apt-get install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

apt-get update
apt-get install -y apt-transport-https 
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Fixing cgroup drivers to use systemd"
mkdir /etc/systemd/system/docker.service.d
cat << EOF >> cgroupf_fix
ExecStart=/usr/bin/dockerd --exec-opt native.cgroupdriver=systemd
EOF

cat <<EOF >> cgroupf_fix_2
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "Overwritting cgroup config"
mv cgroupf_fix_2 /etc/docker/daemon.json
mv cgroupf_fix /etc/systemd/system/docker.service.d/override.conf

# ___________________________
#
# DOWNLOAD AND INSTALL KUBERNETES
#
# ___________________________

echo "Running a system update"
apt-get update -y
echo "Installing Kubeadm, Kubectl and Kubelet"
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl daemon-reload
systemctl restart docker
docker info | grep Cgroup

kubeadm init --pod-network-cidr=10.244.0.0/16 
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml


