#!/bin/bash
sudo -i
consul agent -datacenter=liatsdatacenter -client 0.0.0.0 -ui -data-dir=/tmp/consul -server -bootstrap-expect=3 -retry-join "provider=aws tag_key=Name tag_value=consul region=us-east-1" 