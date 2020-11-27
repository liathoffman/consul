#!/bin/bash
sudo -i
consul agent -data-dir=/tmp/consul -server -datacenter=liatdatacenter -bootstrap-expect 3 -retry-join 'provider=aws tag_key=Name tag_value=consul region=us-east-1'