#!/bin/bash
sudo -i
HOSTNAME = curl http://169.254.169.254/latest/meta-data/hostname
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "This is server with hostname $HOSTNAME" | sudo tee /var/www/html/index.html
mkdir ./consul.d

cat <<EOF > /consul.d/webserver.json
{
   "service":{
      "name":"webserver",
      "port":80,
      "tags":[
         "nginx"
      ],
      "checks":[
         {
            "id":"http",
            "name":"Healthcheck for HTTP",
            "http":"http://localhost:80/",
            "interval":"5s",
            "timeout":"1s"
         }
      ]
   }
}
EOF

consul agent -enable-script-checks -config-dir=./consul.d -datacenter=liatsdatacenter -client 0.0.0.0 -ui -data-dir=/tmp/consul -retry-join "provider=aws tag_key=Name tag_value=consul region=us-east-1"
