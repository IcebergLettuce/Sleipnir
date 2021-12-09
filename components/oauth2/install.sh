sudo certbot --nginx -d pipr.io -d www.pipr.io -d argocd.pipr.io -d www.argocd.pipr.io -d dashboard.pipr.io -d www.dashboard.pipr.io --non-interactive --agree-tos -m manuel.alexander.hirzel@gmail.com
sudo systemctl reload nginx

wget https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.2.0/oauth2-proxy-v7.2.0.linux-amd64.tar.gz
tar -xvf oauth2-proxy-v7.2.0.linux-amd64.tar.gz
sudo chmod +x oauth2-proxy-v7.2.0.linux-amd64/oauth2-proxy

HTTP_PORT=$(sudo kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services traefik)
sed -i "s/@HTTPPORT@/$HTTP_PORT/" oauth2/nginx-auth.conf

sudo cp oauth2/nginx-auth.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx
nohup ./oauth2-proxy-v7.2.0.linux-amd64/oauth2-proxy --config=oauth2/oauth2-proxy.cfg >/dev/null 2>&1 &

