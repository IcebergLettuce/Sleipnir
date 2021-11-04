sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

wget https://github.com/argoproj/argo-cd/releases/download/v2.1.6/argocd-linux-amd64 -O argocd
sudo chmod +x argocd

sudo apt install apache2-utils -y
sudo kubectl patch secret -n argocd argocd-secret -p '{"stringData": { "admin.password": "'$(htpasswd -bnBC 10 "" $ARGOPW | tr -d ':\n')'"}}'