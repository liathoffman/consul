#!/bin/bash
sudo -i
HOSTNAME = curl http://169.254.169.254/latest/meta-data/hostname
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "This is server with hostname $HOSTNAME" | sudo tee /var/www/html/index.html
apt install awscli -y