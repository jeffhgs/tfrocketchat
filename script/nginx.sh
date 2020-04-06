#!/bin/bash
adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt-get install -y nginx jq git

dnsDomainName=$(cat "$adirScript/conf.json" | jq -r ".dnsDomainName")
cluster_name=$(cat "$adirScript/conf.json" | jq -r ".cluster_name")
fqdn=$cluster_name.$dnsDomainName
emailForSsl=$(cat "$adirScript/conf.json" | jq -r ".emailForSsl")

service nginx stop
if [ ! -e "/opt/letsencrypt" ]
then
  git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
fi
(cd /opt/letsencrypt && ./letsencrypt-auto certonly -n --agree-tos  --standalone --email ${emailForSsl} -d ${fqdn})

cat > /tmp/nginx_config_default <<EO10F
server {
  listen 443 ssl;
  server_name ${fqdn};
  ssl_certificate /etc/letsencrypt/live/${fqdn}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${fqdn}/privkey.pem;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
  root /usr/share/nginx/html;
  index index.html index.htm;
  # Make site accessible from http://localhost/
  server_name localhost;
  location / {
    proxy_pass http://localhost:3000/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forward-Proto http;
    proxy_set_header X-Nginx-Proxy true;
    proxy_redirect off;
  }
}
server {
  listen 80;
  server_name ${fqdn};
  return 301 https://\$host\$request_uri;
}
EO10F

cp /tmp/nginx_config_default /etc/nginx/sites-available/default
