#!/bin/bash
sudo -i
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
consul agent -ui -data-dir=/tmp/consul -server -bootstrap-expect=3 -retry-join "provider=aws tag_key=Name tag_value=consul region=us-east-1" 