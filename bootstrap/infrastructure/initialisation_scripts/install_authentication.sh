wget https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.2.0/oauth2-proxy-v7.2.0.linux-amd64.tar.gz
tar -xvf oauth2-proxy-v7.2.0.linux-amd64.tar.gz
sudo chmod +x oauth2-proxy-v7.2.0.linux-amd64/oauth2-proxy
sudo cp initialisation_scripts/deployments/nginx-auth.conf /etc/nginx/nginx.conf
sudo nginx -s reload
 ./oauth2-proxy-v7.2.0.linux-amd64/oauth2-proxy --config=initialisation_scripts/deployments/oauth2-proxy.cfg &