
# Reverse Proxy
sudo apt update
sudo apt install nginx -y

sudo apt-get install certbot -y
sudo apt-get install python3-certbot-nginx -y


HTTP_PORT=$(sudo kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services traefik)
HTTPS_PORT=$(sudo kubectl get -o jsonpath="{.spec.ports[1].nodePort}" services traefik)


sudo systemctl start nginx


cat <<EOF >> stem.conf
events {}
http{
    server {
        listen 80;
        listen [::]:80;

        access_log /var/log/nginx/reverse-access.log;
        error_log /var/log/nginx/reverse-error.log;

        location / {
            proxy_set_header HOST \$http_host;
            proxy_pass http://127.0.0.1:$HTTP_PORT;
        }
        server_name pipr.io www.pipr.io argocd.pipr.io www.argocd.pipr.io dashboard.pipr.io www.dashboard.pipr.io;
}
}
EOF

sudo mv stem.conf /etc/nginx/nginx.conf
sudo systemctl reload nginx

sudo certbot --nginx -d pipr.io -d www.pipr.io -d argocd.pipr.io -d www.argocd.pipr.io -d dashboard.pipr.io -d www.dashboard.pipr.io --non-interactive --agree-tos -m manuel.alexander.hirzel@gmail.com
sudo systemctl reload nginx