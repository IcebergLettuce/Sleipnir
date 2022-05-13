kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml
kubectl patch deployment argocd-server -n argocd --patch "$(cat argocd/argocd-patch.yaml)"
kubectl apply -f argocd/argocd-ingress.
apt install apache2-utils -y
kubectl patch secret -n argocd argocd-secret -p '{"stringData": { "admin.password": "'$(htpasswd -bnBC 10 "" admin | tr -d ':\n')'"}}'