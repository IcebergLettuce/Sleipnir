
sudo apt-get update
sudo apt-get install jq -y

arguments=$(sudo kubectl get deployments traefik -o jsonpath='{.spec.template.spec.containers[0].args}')
echo $arguments | jq '. |= .+ ["--api.insecure=true"] ' > fixargs
sudo kubectl patch deployment traefik --type='json' -p="[{\"op\": \"add\", \"path\": \"/spec/template/spec/containers/0/args\", \"value\": $(cat fixargs)}]"
sleep 50s
sudo kubectl apply -f traefik/deployment.yaml
