sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


sudo kubectl patch deployment argocd-server -n argocd --patch "$(cat initialisation_scripts/deployments/argocd-patch.yaml)"
sudo kubectl apply -f initialisation_scripts/deployments/argocd-ingress.yaml

sudo apt install apache2-utils -y
sudo kubectl patch secret -n argocd argocd-secret -p '{"stringData": { "admin.password": "'$(htpasswd -bnBC 10 "" admin | tr -d ':\n')'"}}'