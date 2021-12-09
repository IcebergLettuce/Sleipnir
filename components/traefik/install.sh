
sudo apt-get update
sudo apt-get install jq -y
sudo kubectl apply -f traefik/deployment.yaml

arguments=$(sudo kubectl get deployments traefik -o jsonpath='{.spec.template.spec.containers[0].args}')
echo $arguments | jq '. |= .+ ["--api.insecure=true"] ' > fixargs
sudo kubectl patch deployment traefik --type='json' -p="[{\"op\": \"add\", \"path\": \"/spec/template/spec/containers/0/args\", \"value\": $(cat fixargs)}]"