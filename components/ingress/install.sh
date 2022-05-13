# ___________________________
#
# DOWNLOAD AND INSTALL TRAEFIK INGRESS CONTROLLER
#
# ___________________________

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik

