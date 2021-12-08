sudo kubectl apply -f traefik/deployment.yaml

sudo kubectl patch deployment \
  traefik \
  --namespace default \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args", "value": [
  "--api.insecure=true",
]}]'