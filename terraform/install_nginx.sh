#!/bin/bash
sudo -i
HOSTNAME = curl http://169.254.169.254/latest/meta-data/hostname
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "This is server with hostname $HOSTNAME" | sudo tee /var/www/html/index.html
consul agent -datacenter=liatsdatacenter -client 0.0.0.0 -ui -data-dir=/tmp/consul -retry-join "provider=aws tag_key=Name tag_value=consul region=us-east-1"
