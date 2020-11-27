#!/bin/bash
git clone --branch v0.8.0  https://github.com/hashicorp/terraform-aws-consul.git
terraform-aws-consul/modules/install-consul/install-consul --version 0.8.0

