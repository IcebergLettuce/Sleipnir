
# ___________________________
#
# DOWNLOAD AND INSTALL TRAEFIK INGRESS CONTROLLER
#
# ___________________________

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik

apt-get update
apt-get install jq -y

arguments=$(sudo kubectl get deployments traefik -o jsonpath='{.spec.template.spec.containers[0].args}')
echo $arguments | jq '. |= .+ ["--api.insecure=true"] ' > fixargs
kubectl patch deployment traefik --type='json' -p="[{\"op\": \"add\", \"path\": \"/spec/template/spec/containers/0/args\", \"value\": $(cat fixargs)}]"
sleep 120s
kubectl apply -f traefik/deployment.yaml